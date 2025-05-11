local M = {}

local schemastore = [[https?://json.schemastore.org/]]

--- get the currently active yaml schema used by yamlls
---@param bufnr number buf number
---@return string
function M.get_schema(bufnr)
  if bufnr == nil then
    bufnr = 0
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'yamlls' })
  if #clients == 0 then
    return ""
  end

  local yamlls_client = clients[1]
  if not yamlls_client.initialized then
    return "unknown"
  end

  local resp, err = yamlls_client.request_sync("yaml/get/jsonSchema", { vim.uri_from_bufnr(bufnr) }, 100, bufnr)
  if err then
    vim.notify(err, vim.log.levels.DEBUG, {})
    return ""
  end

  if not resp then
    return ""
  end

  if resp and resp.err then
    vim.notify(string.format("bufnr=%d error=%s", bufnr, resp.err), vim.log.levels.WARN, {})
    return ""
  end

  local stat = resp.result[1]

  if stat.name then
    return stat.name
  end

  local uri = stat.uri
  local sc, _ =  string.gsub(uri, schemastore, "")
  return sc
end

return M
