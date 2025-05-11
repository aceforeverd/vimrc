local M = {}

local extra_schemas = {
  -- check default in https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
  kubernetes = { 'k8s-*.{yaml,yml}', '*-k8s.{yaml,yml}' },
  ['https://json.schemastore.org/github-workflow'] = {'.github/workflows/*'},
  ['https://json.schemastore.org/github-action'] = {'.github/action.{yml,yaml}'},
  ['https://json.schemastore.org/ansible-stable-2.9'] = {'roles/tasks/**/*.{yml,yaml}'},
  ['https://json.schemastore.org/prettierrc'] = {'.prettierrc.{yml,yaml}'},
  ['https://json.schemastore.org/kustomization'] = {'kustomization.{yml,yaml}'},
  ['https://json.schemastore.org/chart'] = {'Chart.{yml,yaml}'},
  ['https://json.schemastore.org/circleciconfig'] = {'.circleci/**/*.{yml,yaml}'},
  ['https://json.schemastore.org/prometheus'] = { 'prometheus*.yml', 'prometheus*.yaml' },
}

M.lsp_cfg = {
  settings = {
    yaml = {
      -- or setup with inlined schema: https://github.com/redhat-developer/yaml-language-server?tab=readme-ov-file#using-inlined-schema
      -- format: # yaml-language-server: $schema=<urlToTheSchema>
      schemas = extra_schemas,
    },
  },
}

local schemastore = [[https?://json.schemastore.org/]]

function M.get_yamlls()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'yamlls' })
  if #clients == 0 then
    return nil
  end

  return clients[1]
end

--- get the currently active yaml schema used by yamlls
---@return string
function M.get_schema()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'yamlls' })
  if #clients == 0 then
    return ""
  end

  local yamlls_client = clients[1]
  if not yamlls_client.initialized then
    return "unknown"
  end

  local resp, err = yamlls_client.request_sync("yaml/get/jsonSchema", { vim.uri_from_bufnr(0) }, 100, 0)
  if err then
    return ""
  end

  if not resp then
    return ""
  end

  if resp and resp.err then
    vim.notify(string.format("bufnr=%d error=%s", vim.fn.bufnr(0), resp.err), vim.log.levels.WARN, {})
    return ""
  end

  if not resp.result or #resp.result == 0 then
    return ""
  end

  local stat = resp.result[1]

  if stat.name then
    return stat.name
  end

  local uri = stat.uri
  local sc, _ =  string.gsub(uri, schemastore, "")
  return sc or ""
end

function M.select_schema()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'yamlls' })
  if #clients == 0 then
    return ""
  end

  local yamlls_client = clients[1]
  if not yamlls_client.initialized then
    vim.log.notify("yamlls not ready", vim.log.levels.INFO, {})
    return
  end

  local cur_sc = M.get_schema()

  local resp, err = yamlls_client.request_sync("yaml/get/all/jsonSchemas", { vim.uri_from_bufnr(0) })
  if err then
    vim.notify(err, vim.log.levels.WARN, {})
    return
  end
  if not resp or resp.err then
    vim.notify(string.format("bufnr=%d error=%s", vim.fn.bufnr(0), resp.err), vim.log.levels.WARN, {})
    return
  end

  vim.ui.select(resp.result, {
    prompt = 'Select new schema, current ' .. cur_sc,
    format_item = function(schema)
      if schema.name and schema.name ~= "" then
        return schema.name
      end

      return schema.uri
    end,
  }, function (item)
      if item then
        vim.notify("selected " .. vim.inspect(item.uri), vim.log.levels.INFO, {})

        local client = M.get_yamlls()
        if not client then
          vim.notify("no yamlls server", vim.log.levels.INFO, {})
          return
        end

        -- remove explict entry if exists in old schema
        local schemas = client.settings.yaml.schemas

        local new_value = vim.uri_from_bufnr(0)
        for key, value in pairs(schemas) do
          -- value always be a table
          if key == item.uri then
            -- on new key
            if value[#value] ~= new_value then
              table.insert(value, new_value)
              schemas[key] = value
            end
          else
            while value[#value] == new_value do
              table.remove(value, #value)
            end
            schemas[key] = value
          end
        end
        -- in case default schemas
        if schemas[item.uri] == nil then
          schemas[item.uri] = { new_value }
        end

        client.settings.yaml.schemas = schemas

        client.notify("workspace/didChangeConfiguration", {
          settings = client.settings
        })
      end
  end)

end

return M
