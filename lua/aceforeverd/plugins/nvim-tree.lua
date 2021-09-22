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
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_width = '20%'
vim.g.nvim_tree_respect_buf_cwd = 1
