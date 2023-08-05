local base = 'https://api.github.com/repo/'

function GetRepo(repo)
  local curl = require('plenary.curl')
  return curl.get(base .. repo)
end

function GetOldPlugins()
  local plugins = vim.fn['minpac#getpluglist']()
  local out = {}
  for _, value in pairs(plugins) do
    local url = value['url']
    local repo = vim.fn.substitute(url, [[^https://github.com/]], '', '')
    local stats = GetRepo(repo)

    if stats ~= nil and stats.archived == true then
      table.insert(out, {value, 'archived'})
    end
  end

  vim.api.nvim_notify(vim.inspect(out), vim.log.levels.INFO, {})
end

return {
  GetOldPlugins = GetOldPlugins
}
