---@param opts table ast grep search pattern
local function ast_grep_search(opts)
  local args = opts.fargs
  local pattern = args[1]

  local cmds = { 'sg', 'run', '--heading', 'never', '--pattern', pattern }
  for i = 2, #args, 1 do
    table.insert(cmds, args[i])
  end

  local expr = string.format(
    'system([%s])',
    vim.iter(cmds):map(function(v)
      return vim.fn.shellescape(v)
    end):join(", ")
  )
  vim.cmd('lgetexpr ' .. expr)
  vim.cmd('lopen')
end

return {
  select_browse_plugin = require('aceforeverd.keymap.plugin_browse').select_browse_plugin,
  ast_grep_search = ast_grep_search,
}
