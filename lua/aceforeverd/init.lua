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

vim.api.nvim_command([[
    let s:home = expand('<sfile>:p:h')
    let &packpath = &packpath . ',' . s:home
    ]])

vim.g.material_style = 'palenight'
vim.g.material_italic_comments = 1

vim.api.nvim_set_keymap('n', '<C-n>',
                        [[<Cmd>lua require('material').toggle_style()<CR>]],
                        {noremap = true, silent = true})

require('aceforeverd.plugins')

vim.cmd [[
    packadd nvim-treesitter
    packadd nvim-lspconfig
    ]]
