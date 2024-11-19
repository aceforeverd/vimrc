local base = 'https://api.github.com/repo/'

function GetRepo(repo)
  local curl = require('plenary.curl')
  return curl.get(base .. repo)
end

function GetOldPlugins()
  -- minpac plugins
  local plugins = vim.fn['minpac#getpluglist']()
  local out = {}
  for _, value in pairs(plugins) do
    local url = value['url']
    local repo = vim.fn.substitute(url, [[^https://github.com/]], '', '')
    local stats = GetRepo(repo)

    if stats ~= nil and stats.archived == true then
      table.insert(out, repo)
    else
      vim.notify('ok: ' .. repo, vim.log.levels.INFO, {})
    end
  end

  -- lazy plugins
  local lua_plugins = require('aceforeverd.plugins').plugin_list
  for _, value in pairs(lua_plugins) do
    local stats = GetRepo(value[0])

    if stats ~= nil and stats.archived == true then
      table.insert(out, value[0])
    else
      vim.notify('ok: ' .. value[0], vim.log.levels.INFO, {})
    end
  end

  vim.notify('archived: ' .. vim.inspect(out), vim.log.levels.INFO, {})
end

return {
  GetOldPlugins = GetOldPlugins
}
