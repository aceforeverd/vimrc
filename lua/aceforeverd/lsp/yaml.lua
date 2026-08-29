local M = {}

local extra_schemas = {
  -- check default in https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
  kubernetes = { 'k8s-*.{yaml,yml}', '*-k8s.{yaml,yml}' },
  ['https://json.schemastore.org/github-workflow'] = { '.github/workflows/*' },
  ['https://json.schemastore.org/github-action'] = { '.github/action.{yml,yaml}' },
  ['https://json.schemastore.org/ansible-stable-2.9'] = { 'roles/tasks/**/*.{yml,yaml}' },
  ['https://json.schemastore.org/prettierrc'] = { '.prettierrc.{yml,yaml}' },
  ['https://json.schemastore.org/kustomization'] = { 'kustomization.{yml,yaml}' },
  ['https://json.schemastore.org/chart'] = { 'Chart.{yml,yaml}' },
  ['https://json.schemastore.org/circleciconfig'] = { '.circleci/**/*.{yml,yaml}' },
  ['https://json.schemastore.org/prometheus'] = { 'prometheus*.yml', 'prometheus*.yaml' },
}

local schemastore = [[https?://json.schemastore.org/]]

-- yamlls rewrites the magic 'kubernetes' key into this url (checkSchemaURI/isKubernetes in
-- yaml-language-server), so the schema picker reports the url and never the key we configured.
local k8s_schema_pattern =
  [[^https://raw%.githubusercontent%.com/yannh/kubernetes%-json%-schema/master/v%d+%.%d+%.%d+%-standalone%-strict/all%.json$]]

--- map a schema uri reported by yamlls back to the key we use in settings.yaml.schemas
--- @param uri string
--- @return string
local function schema_key(uri)
  if uri:match(k8s_schema_pattern) then
    return 'kubernetes'
  end
  return uri
end

--- drop every occurrence of `uri` from a fileMatch list, at any position
--- @param patterns string[]
--- @param uri string
local function drop_file_match(patterns, uri)
  for i = #patterns, 1, -1 do
    if patterns[i] == uri then
      table.remove(patterns, i)
    end
  end
end

--- check yamlls is up and ready for current buffer
--- @param bufnr number
--- @return vim.lsp.Client | nil
function M.get_yamlls(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'yamlls' })
  if #clients == 0 then
    return nil
  end

  local yamlls_client = clients[1]
  if not yamlls_client.initialized then
    return nil
  end
  return yamlls_client
end

local function get_schema_data(bufnr)
  -- lualine rely on this method, do not log in INFO or above
  local yamlls_client = M.get_yamlls(bufnr)
  if not yamlls_client then
    return nil
  end

  local resp, err = yamlls_client:request_sync('yaml/get/jsonSchema', { vim.uri_from_bufnr(bufnr) }, 100, bufnr) ---@diagnostic disable-line: param-type-mismatch
  if err then
    vim.notify(string.format('yamlls error bufnr=%d: %s', bufnr, err), vim.log.levels.DEBUG, {})
    return nil
  end

  if not resp then
    return nil
  end

  if resp.err then
    vim.notify(string.format('bufnr=%d error=%s', bufnr, resp.err), vim.log.levels.DEBUG, {})
    return nil
  end

  if not resp.result or #resp.result == 0 then
    return nil
  end

  return resp.result[1]
end

--- get the currently active yaml schema used by yamlls
---@return string
function M.get_schema()
  local stat = get_schema_data(0)
  if not stat then
    return ''
  end

  if stat.name then
    return stat.name
  end

  local uri = stat.uri
  local sc, _ = string.gsub(uri, schemastore, '')
  return sc or ''
end

--- write current yaml schema as modeline for buffer
--- ref https://github.com/redhat-developer/yaml-language-server?tab=readme-ov-file#using-inlined-schema
local function inline_schema()
  local stat = get_schema_data(0)
  if not stat then
    vim.notify('yamlls not up or ready for buffer ' .. vim.uri_from_bufnr(0), vim.log.levels.WARN, {})
    return
  end

  if stat.uri then
    local modeline = string.format('# yaml-language-server: $schema=%s', stat.uri)
    -- write modeline at top
    vim.cmd([[normal! gg]])
    vim.api.nvim_put({ modeline }, 'l', false, false)
    return
  end

  vim.notify('no schema uri found')
end

function M.select_schema()
  local yamlls_client = M.get_yamlls(0)
  if not yamlls_client then
    vim.notify('yamlls not up or ready for buffer ' .. vim.uri_from_bufnr(0), vim.log.levels.INFO, {})
    return
  end

  local cur_sc = M.get_schema()

  -- the buffer uri is required, without it yamlls can not tell which entries apply to this file
  local resp, err = yamlls_client:request_sync('yaml/get/all/jsonSchemas', { vim.uri_from_bufnr(0) }, 100, 0) ---@diagnostic disable-line: param-type-mismatch
  if err then
    vim.notify(err, vim.log.levels.WARN, {})
    return
  end
  if not resp then
    vim.notify('yamlls did not answer yaml/get/all/jsonSchemas', vim.log.levels.WARN, {})
    return
  end
  if resp.err then
    vim.notify(string.format('bufnr=%d error=%s', vim.fn.bufnr(0), resp.err), vim.log.levels.WARN, {})
    return
  end

  vim.ui.select(resp.result, {
    prompt = 'Select new schema, current ' .. cur_sc,
    format_item = function(schema)
      local label = schema.uri
      if schema.name and schema.name ~= '' then
        label = schema.name
      end

      -- mark the entries yamlls currently applies to this buffer
      return (schema.usedForCurrentFile and '* ' or '  ') .. label
    end,
  }, function(selected, idx)
    if selected then
      vim.notify(string.format('selected %dth %s', idx, vim.inspect(selected.uri)), vim.log.levels.INFO, {})

      local client = M.get_yamlls(0)
      if not client then
        vim.notify('no yamlls server', vim.log.levels.INFO, {})
        return
      end

      local schemas = client.settings.yaml.schemas
      local buf_uri = vim.uri_from_bufnr(0)
      -- 'kubernetes' and its resolved url are the same association to yamlls, keep using the key
      -- we configured so we never end up with two entries pointing at the same schema
      local selected_key = schema_key(selected.uri)

      -- every leftover association still listing this buffer stays active alongside the new one,
      -- and yamlls then validates against the highest priority match only (an auto detected
      -- kubernetes sub schema has priority 0 and always loses), so drop them all
      for k, patterns in pairs(schemas) do
        if k ~= selected_key and type(patterns) == 'table' then
          drop_file_match(patterns, buf_uri)
        end
      end

      -- in case of default schemas the key does not exist yet
      local target = schemas[selected_key] or {}
      if not vim.tbl_contains(target, buf_uri) then
        table.insert(target, buf_uri)
      end
      schemas[selected_key] = target

      client.settings.yaml.schemas = schemas

      -- yamlls ignores the pushed payload and pulls 'yaml' back via workspace/configuration,
      -- which nvim answers from client.settings, so the mutation above is what actually lands
      client:notify('workspace/didChangeConfiguration', {
        settings = client.settings,
      })
    end
  end)
end

M.lsp_cfg = {
  -- Have to add this for yamlls to understand that we support line folding
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
      completion = {
        -- ? not sure, by default it should off
        dynamicRegistration = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    require('aceforeverd.lsp.common').on_attach(client, bufnr)

    -- require nvim 0.10
    -- Neovim < 0.10 does not have dynamic registration for formatting
    client.server_capabilities.documentFormattingProvider = true

    vim.api.nvim_buf_create_user_command(0, 'YAMLSchema', function()
      local sc = M.get_schema()
      if sc == '' then
        vim.notify('no yaml schema for ' .. vim.uri_from_bufnr(0), vim.log.levels.INFO, {})
        return
      end
      vim.notify(sc, vim.log.levels.INFO, {})
    end, { nargs = 0 })
    vim.api.nvim_buf_create_user_command(0, 'YAMLSelectSchema', M.select_schema, { nargs = 0 })
    vim.api.nvim_buf_create_user_command(0, 'YAMLInlineSchema', inline_schema, { nargs = 0 })
  end,
  settings = {
    yaml = {
      hover = true,
      format = {
        enable = true,
        printWidth = 120,
      },
      -- or setup with inlined schema: https://github.com/redhat-developer/yaml-language-server?tab=readme-ov-file#using-inlined-schema
      -- format: # yaml-language-server: $schema=<urlToTheSchema>
      schemas = vim.deepcopy(extra_schemas),
      schemaStore = {
        enable = true,
        url = 'https://www.schemastore.org/api/json/catalog.json',
      },
      kubernetesVersion = '1.36.3',
      kubernetesCRDStore = {
        enable = true,
      },
    },
  },
}

return M
