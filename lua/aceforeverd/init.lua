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
require('aceforeverd.plugins')

vim.cmd [[
    packadd nvim-lspconfig
    ]]

vim.g.material_style = 'darker'
vim.g.material_italic_comments = 1

vim.api.nvim_set_keymap('n', '<c-n>',
                        [[<Cmd>lua require('material.functions').toggle_style()<CR>]],
                        {noremap = true, silent = true})

local material = require('material')
material.set()
