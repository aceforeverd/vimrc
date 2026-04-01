local base = 'https://api.github.com/repos/'
local curl_timeout = 10000

local function get_github_token()
  local token = os.getenv('GITHUB_TOKEN')
  if token and token ~= '' then
    return token
  end

  local token_file = vim.fn.expand('~/.github_token')
  if vim.fn.filereadable(token_file) == 1 then
    local lines = vim.fn.readfile(token_file)
    if #lines > 0 then
      return vim.trim(lines[1])
    end
  end
  return nil
end

--- check if a plugin repo is archived, or long time no update
---@param repo string path to repo, format: 'username/repo'
---@param callback function(stats)
local function check_archived_async(repo, callback)
  if repo == nil or repo == '' then
    callback({ err_msg = 'invalid repo' })
    return
  end

  local curl = require('plenary.curl')
  local token = get_github_token()
  local headers = {
    ['Accept'] = 'application/vnd.github.v3+json',
  }
  if token then
    headers['Authorization'] = 'token ' .. token
  end

  curl.get(base .. repo, {
    timeout = curl_timeout,
    headers = headers,
    callback = function(stat)
      if stat.exit ~= 0 then
        callback({ err_msg = string.format('curl error: exit=%d', stat.exit) })
        return
      end

      local ok, body = pcall(vim.json.decode, stat.body)
      if not ok then
        callback({ err_msg = 'failed to decode response body' })
        return
      end

      if stat.status ~= 200 then
        local msg = body.message or 'Unknown error'
        local err_msg = string.format('HTTP %d: %s', stat.status, msg)
        if stat.status == 401 then
          err_msg = 'HTTP 401: Unauthorized (check your token)'
        elseif stat.status == 403 then
          if msg:find('rate limit') then
            err_msg = 'HTTP 403: Rate limit exceeded'
          else
            err_msg = 'HTTP 403: Forbidden'
          end
        elseif stat.status == 404 then
          err_msg = 'HTTP 404: Not Found (repo might be deleted or private)'
        end
        callback({ err_msg = err_msg })
        return
      end

      callback(body)
    end,
  })
end

local function show_results_ui(plugin_repos)
  local Popup = require('nui.popup')
  local event = require('nui.utils.autocmd').event

  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = ' Plugin Archive Check ',
        top_align = 'center',
      },
    },
    position = '50%',
    size = {
      width = '80%',
      height = '60%',
    },
  })

  popup:mount()

  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  local bufnr = popup.bufnr
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

  local results = {}
  local total = #plugin_repos
  local finished = 0
  local archived_repos = {}

  local function update_view()
    local lines = {
      string.format('Progress: %d/%d', finished, total),
      '',
    }

    for _, res in ipairs(results) do
      local status_text = ''
      local hl_group = ''
      if res.status == 'checking' then
        status_text = 'Checking...'
        hl_group = 'Comment'
      elseif res.status == 'ok' then
        status_text = 'OK'
        hl_group = 'DiagnosticInfo'
      elseif res.status == 'archived' then
        status_text = 'ARCHIVED'
        hl_group = 'DiagnosticWarn'
      elseif res.status == 'error' then
        status_text = 'ERROR: ' .. res.err_msg
        hl_group = 'DiagnosticError'
      end
      table.insert(lines, string.format('%-40s %s', res.repo, status_text))
    end

    if finished == total then
      table.insert(lines, '')
      table.insert(lines, 'Summary:')
      if #archived_repos > 0 then
        table.insert(lines, 'Archived plugins found:')
        for _, repo in ipairs(archived_repos) do
          table.insert(lines, '  - ' .. repo)
        end
      else
        table.insert(lines, 'No archived plugins found.')
      end
    end

    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

      -- Add highlights
      for i, res in ipairs(results) do
        local hl = 'Comment'
        if res.status == 'ok' then
          hl = 'DiagnosticInfo'
        elseif res.status == 'archived' then
          hl = 'DiagnosticWarn'
        elseif res.status == 'error' then
          hl = 'DiagnosticError'
        end
        vim.api.nvim_buf_add_highlight(bufnr, -1, hl, i + 1, 41, -1)
      end

      vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
    end)
  end

  for i, repo in ipairs(plugin_repos) do
    results[i] = { repo = repo, status = 'checking' }
  end
  update_view()

  for i, repo in ipairs(plugin_repos) do
    check_archived_async(repo, function(stats)
      finished = finished + 1
      if stats.err_msg then
        results[i].status = 'error'
        results[i].err_msg = stats.err_msg
      elseif stats.archived then
        results[i].status = 'archived'
        table.insert(archived_repos, repo)
      else
        results[i].status = 'ok'
      end
      update_view()
    end)
  end
end

function GetOldPlugins()
  local plugin_repos = {}

  -- minpac plugins (legacy support as per original script)
  local ok_minpac, minpac_plugins = pcall(vim.fn['aceforeverd#plugin#list'])
  if ok_minpac then
    for _, value in pairs(minpac_plugins) do
      local url = value['url']
      local repo = vim.fn.substitute(url, [[^https://github.com/]], '', '')
      repo = vim.fn.substitute(repo, [[\.git$]], '', '')
      if not vim.tbl_contains(plugin_repos, repo) then
        table.insert(plugin_repos, repo)
      end
    end
  end

  -- lazy plugins
  local ok_lazy, lua_plugins = pcall(function()
    return require('aceforeverd.plugins').plugin_list
  end)
  if ok_lazy then
    for _, value in pairs(lua_plugins) do
      local repo = value[1] or value[0] -- lazy spec can be { "user/repo" } or { [0] = "user/repo" }
      if type(repo) == 'string' and not repo:find('http') and not vim.tbl_contains(plugin_repos, repo) then
        table.insert(plugin_repos, repo)
      end
    end
  end

  if #plugin_repos == 0 then
    vim.notify('No plugins found to check.', vim.log.levels.WARN)
    return
  end

  show_results_ui(plugin_repos)
end

return {
  GetOldPlugins = GetOldPlugins,
}
