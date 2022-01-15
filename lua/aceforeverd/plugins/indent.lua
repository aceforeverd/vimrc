-- Copyright (C) 2022  Ace <teapot@aceforeverd.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local M = {}

function M.setup()
  -- set list
  vim.opt.list = true
  vim.opt.listchars:append('space:⋅')

  require('indent_blankline').setup({
    char_list = { '|', '¦', '┆', '┊' },
    space_char_blankline = ' ',
    show_trailing_blankline_indent = false,
    buftype_exclude = { 'terminal' },
    filetype_exclude = { 'startify', 'coc-explorer', 'NvimTree', 'help', 'git', 'packer', 'lsp-installer' },
  })
end

return M
