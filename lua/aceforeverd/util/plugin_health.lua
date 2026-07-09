local default_base = 'https://api.github.com/repos/'
local default_curl_timeout = 10000
local default_curl_parallel = 20

local scoped_task = nil

--- check if a plugin repo is archived, or long time no update
---@param repo string path to repo, format: 'username/repo'
---@param callback function(stats)
local function check_archived_async(repo, timeout, token, callback)
  if repo == nil or repo == '' then
    callback({ err_msg = 'invalid repo' })
    return
  end

  local curl = require('plenary.curl')
  local headers = {
    ['Accept'] = 'application/vnd.github.v3+json',
  }
  if token then
    headers['Authorization'] = 'token ' .. token
  end

  return curl.get(default_base .. repo, {
    timeout = timeout,
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
--- type definitions

--- @class Task
--- @field repos string[]
--- @field opts {timeout: number, parallel: number, github_token: string}
--- @field stat table
--- @field ui {bufnr: number, popup: NuiPopup}
local Task = {}
Task.__index = Task

---@param repo_list string[]
---@param opts {timeout: number, parallel: number, github_token: string}
function Task:new(repo_list, opts)
  local fetch_state = {
    idx = 0,
    finished = 0,
    total = #repo_list,
    results = {},
    archived_repos = {},
    check_cache = {},
    line_to_res = {},
  }
  local ui_stat = {
    bufnr = -1, -- not created yet
  }
  local task = { repos = repo_list, opts = opts, stat = fetch_state, ui = ui_stat }
  return setmetatable(task, Task)
end

-- reset fetch to initial state
function Task:reset()
  self.stat = {
    results = {},
    finished = 0,
    archived_repos = {},
    check_cache = {},
    idx = 1,
    total = #self.repos,
    line_to_res = {},
  }
end

function Task:init_ui()
  -- init UI elements
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
    position = '60%',
    size = {
      width = '80%',
      height = '80%',
    },
  })

  popup:mount()

  local bufnr = popup.bufnr
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })

  self.ui.bufnr = bufnr
  self.ui.popup = popup

  popup:on(event.VimResized, function()
    popup:update_layout({
      position = '60%',
      size = {
        width = '80%',
        height = '80%',
      },
    })
  end)

  popup:on(event.QuitPre, function()
    self.ui.bufnr = -1
    scoped_task = nil
  end)

  vim.keymap.set('n', '<CR>', function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]
    local res = self.stat.line_to_res[row]
    if res then
      res.expanded = not res.expanded
      self:update_view()
    end
  end, { buffer = bufnr, silent = true })
  vim.keymap.set('n', 'R', function()
    self:restart_check()
  end, { buffer = bufnr, silent = true })
  vim.keymap.set('n', 'q', function()
    if self.ui.popup then
      self.ui.popup:hide()
    end
  end, { buffer = bufnr, silent = true })
end

-- start fetch & draw the UI
function Task:start()
  self:reset()
  self:init_ui()
  self:start_check()
end

function Task:is_ui_valid()
  return self.ui.popup ~= nil and self.ui.bufnr ~= -1 and vim.api.nvim_buf_is_valid(self.ui.bufnr)
end

function Task:resume_ui()
  if not self:is_ui_valid() then
    self:init_ui()
  else
    self.ui.popup:show()
  end
  self:update_view()
end

function Task:restart_check()
  self:reset()
  self:start_check()
end

function Task:start_check()
  local stat = self.stat
  for i, repo in ipairs(self.repos) do
    if stat.check_cache[repo] then
      stat.results[i] = {
        repo = repo,
        status = stat.check_cache[repo].status,
        err_msg = stat.check_cache[repo].err_msg,
        pushed_at = stat.check_cache[repo].pushed_at,
      }
      stat.finished = stat.finished + 1
      if stat.check_cache[repo].status == 'archived' then
        table.insert(stat.archived_repos, repo)
      end
    else
      stat.results[i] = { repo = repo, status = 'checking' }
    end
  end
  self:update_view()

  for _ = 1, self.opts.parallel do
    self:spawn_next()
  end
end

function Task:spawn_next()
  local stat = self.stat
  if stat.idx > stat.total then
    return
  end

  local i = stat.idx
  local repo = self.repos[i]
  if stat.check_cache[repo] ~= nil then
    self:spawn_next()
    return
  end

  stat.idx = i + 1
  check_archived_async(repo, self.opts.timeout, self.opts.github_token, function(stats)
    stat.finished = stat.finished + 1

    if stats.err_msg then
      stat.results[i].status = 'error'
      stat.results[i].err_msg = stats.err_msg
    elseif stats.archived then
      stat.results[i].status = 'archived'
      table.insert(stat.archived_repos, repo)
    else
      stat.results[i].status = 'ok'
      stat.results[i].pushed_at = stats.pushed_at
    end
    stat.check_cache[repo] =
      { status = stat.results[i].status, err_msg = stat.results[i].err_msg, pushed_at = stat.results[i].pushed_at }
    self:update_view()

    self:spawn_next()
  end)
end

function Task:update_view()
  local stat = self.stat
  local lines = {
    string.format('Progress: %d/%d', stat.finished, stat.total),
    '',
  }
  stat.line_to_res = {}

  local sorted_results = {}
  for _, res in ipairs(stat.results) do
    local status_text = ''
    local hl_group = 'Comment'
    local sort_weight = 1

    if res.status == 'checking' then
      status_text = '⟳ Checking...'
      sort_weight = 1
    elseif res.status == 'archived' then
      status_text = '󰈺 ARCHIVED'
      hl_group = 'DiagnosticWarn'
      sort_weight = 2
    elseif res.status == 'error' then
      status_text = '✗ ERROR: ' .. res.err_msg
      hl_group = 'DiagnosticError'
      sort_weight = 3
    elseif res.status == 'ok' then
      status_text = '✓ OK'
      hl_group = 'DiagnosticInfo'
      sort_weight = 4
      if res.pushed_at then
        local year, month, day = res.pushed_at:match('(%d%d%d%d)-(%d%d)-(%d%d)')
        if year and month and day then
          local pushed_time = os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) })
          local current_time = os.time()
          local diff_days = os.difftime(current_time, pushed_time) / (24 * 3600)
          status_text = string.format('✓ OK (Last update: %s-%s-%s)', year, month, day)
          if diff_days <= 365 then
            hl_group = 'DiagnosticOk'
          else
            hl_group = 'DiagnosticWarn'
          end
        end
      end
    end
    res.computed_hl = hl_group
    res.computed_text = status_text
    res.sort_weight = sort_weight
    table.insert(sorted_results, res)
  end

  table.sort(sorted_results, function(a, b)
    if a.sort_weight ~= b.sort_weight then
      return a.sort_weight < b.sort_weight
    end
    if a.sort_weight == 4 then
      local date_a = a.pushed_at or '9999-99-99'
      local date_b = b.pushed_at or '9999-99-99'
      if date_a ~= date_b then
        return date_a < date_b
      end
    end
    return a.repo < b.repo
  end)

  for _, res in ipairs(sorted_results) do
    table.insert(lines, string.format('%-40s %s', res.repo, res.computed_text))
    stat.line_to_res[#lines] = res

    if res.expanded then
      table.insert(lines, '  └─ URL: https://github.com/' .. res.repo)
    end
  end

  if stat.finished == stat.total then
    -- TODO: move this summary into top. Notice update_view rely on some magic line idx to draw
    table.insert(lines, '')
    table.insert(lines, 'Summary:')
    if #stat.archived_repos > 0 then
      table.insert(lines, 'Archived plugins found:')
      for _, repo in ipairs(stat.archived_repos) do
        table.insert(lines, '  - ' .. repo)
      end
    else
      table.insert(lines, 'No archived plugins found.')
    end
  end

  vim.schedule(function()
    if not self:is_ui_valid() then
      vim.notify('internal error: popui corrupted', vim.log.levels.ERROR)
      return
    end

    local bufnr = self.ui.bufnr
    vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    -- Add highlights
    local line_num = 3
    local ns = vim.api.nvim_create_namespace('archived')
    for _, res in ipairs(sorted_results) do
      local hl = res.computed_hl or 'Comment'
      local col_len = lines[line_num] and #lines[line_num] or 41
      vim.api.nvim_buf_set_extmark(bufnr, ns, line_num - 1, 41, { end_col = col_len, hl_group = hl })
      line_num = line_num + 1
      if res.expanded then
        local exp_len = lines[line_num] and #lines[line_num] or 0
        vim.api.nvim_buf_set_extmark(bufnr, ns, line_num - 1, 0, { end_col = exp_len, hl_group = 'Comment' })
        line_num = line_num + 1
      end
    end

    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  end)
end

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

local function check_plugin_health()
  if scoped_task ~= nil then
    scoped_task:resume_ui()
    return
  end

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

  local token = get_github_token()
  if token == nil then
    vim.notify(
      'you need setup a GitHub token otherwise the check ususally wont success because of API rate limit',
      vim.log.levels.WARN,
      {}
    )
    return
  end

  local task =
    Task:new(plugin_repos, { timeout = default_curl_timeout, parallel = default_curl_parallel, github_token = token })
  scoped_task = task
  task:start()
end

return {
  check_plugin_health = check_plugin_health,
}
