local base = 'https://api.github.com/repos/'

local curl_timeout = 10000

--- check if a plugin repo is archived, or long time no update
---@param repo string path to repo, format: 'username/repo'
---@return {archived: boolean, err_msg: string}
local function check_archived(repo)
  if repo == nil or repo == '' then
    return {err_msg = "invalid repo"}
  end


  -- require authorization or rate limit will easily hit, use gh if applicable
  local curl = require('plenary.curl')
  -- use pcall to catch error throw by curl.get
  local ok, stat = pcall(curl.get, base .. repo, { timeout = curl_timeout })
  if not ok then
    return { err_msg = stat }
  end
  if stat.exit ~= 0 or stat.status ~= 200 then
    local msg = stat.body.message or vim.inspect(stat.body)
    return { err_msg = string.format('exit=%d, status=%d, message: %s', stat.exit, stat.status, msg) }
  end

  return stat.body
end

function GetOldPlugins()
  -- minpac plugins
  local plugins = vim.fn['aceforeverd#plugin#list']()
  local out = {}
  for _, value in pairs(plugins) do
    local url = value['url']
    local repo = vim.fn.substitute(url, [[^https://github.com/]], '', '')
    repo = vim.fn.substitute(repo, [[\.git$]], '', '')
    local stats = check_archived(repo)
    if stats ~= nil then
      if stats.err_msg ~= nil then
        vim.notify(string.format('%s error: %s', repo, stats.err_msg), vim.log.levels.WARN, {})
      elseif stats.archived == true then
        table.insert(out, repo)
      end
    end
  end

  -- lazy plugins
  local lua_plugins = require('aceforeverd.plugins').plugin_list
  for _, value in pairs(lua_plugins) do
    local repo = value[0]
    local stats = check_archived(repo)
    if stats ~= nil then
      if stats.err_msg ~= nil then
        vim.notify(string.format('%s error: %s', repo, stats.err_msg), vim.log.levels.WARN, {})
      elseif stats.archived == true then
        table.insert(out, repo)
      else
        vim.notify(string.format("%s: ok", repo), vim.log.levels.INFO, {})
      end
    end
  end

  vim.notify('archived: ' .. vim.inspect(out), vim.log.levels.INFO, {})
end

return {
  GetOldPlugins = GetOldPlugins,
}
