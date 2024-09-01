return {
  setup = function()
    vim.keymap.set('n', '<leader>cd', function()
      require('aceforeverd.cd').find_root({ fn = vim.fn['FindRootDirectory'], hint = 'vim-rooter' })
    end, { desc = 'set root directory', remap = false })
  end,
  select_browse_plugin = require('aceforeverd.keymap.plugin_browse').select_browse_plugin,
}
