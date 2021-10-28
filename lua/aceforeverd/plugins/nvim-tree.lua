-- Copyright (C) 2021  Ace <teapot@aceforeverd.com>
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
vim.api.nvim_set_keymap('n', '<Space>r', [[ <Cmd>lua require 'nvim-tree'.toggle()<CR> ]],
                        { noremap = true, silent = false })
vim.g.nvim_tree_respect_buf_cwd = 1

require('nvim-tree').setup {
  disable_netrw = false,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  update_to_buf_dir = { enable = true, auto_open = true },
  auto_close = false,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = { hint = "", info = "", warning = "", error = "" }
  },
  update_focused_file = { enable = true, update_cwd = true, ignore_list = {} },
  system_open = { cmd = nil, args = {} },
  view = {
    width = '20%',
    side = 'left',
    auto_resize = true,
    mappings = { custom_only = false, list = {} }
  }
}
