local function snacks(opts)
  local snacks = require('snacks')

  snacks.setup(opts)

  vim.api.nvim_create_user_command('SPicker', function()
    snacks.picker()
  end, {})
  vim.api.nvim_create_user_command('SNotifyHistory', function()
    snacks.notifier.show_history()
  end, {})

  require('aceforeverd.util.map').do_map({
    n = {
      ['<leader>g'] = {
        ['b'] = {
          function()
            -- snacks have methods useful only
            -- custom to open repo/branch/file/permalink ...
            -- it try to smart guess the open type
            -- for multiple git remotes, ui select comes
            snacks.gitbrowse.open()
          end,
          { desc = 'git open browse' },
        },
      },
    },
  }, { noremap = true })
end

return {
  snacks = snacks,
}
