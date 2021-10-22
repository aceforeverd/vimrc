-- set list
vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup {
  char_list = { '|', '¦', '┆', '┊' },
  space_char_blankline = " ",
  show_trailing_blankline_indent = false,
  buftype_exclude = { "terminal" },
  filetype_exclude = { "startify", "coc-explorer", "NvimTree", "help", "git", "packer", 'lsp-installer' },
}
