-- runs a lua expr and print its results
local function inspect(opts)
  local res = vim.api.nvim_eval('luaeval("' .. vim.fn.escape(opts.args, '"') .. '")')
  vim.notify(vim.inspect(res), vim.log.levels.INFO, {})
end

return {
  setup = function()
    vim.api.nvim_create_user_command('LuaInspect', inspect, { complete = 'lua', nargs = 1 })

    -- Sg <pattern> [<dir1> <dir2> ...]
    vim.api.nvim_create_user_command(
      'Sg',
      require('aceforeverd.keymap.init').ast_grep_search,
      -- TODO: custom complete function
      { nargs = '+', desc = 'ast grep search', complete = 'dir' }
    )
  end,
}
