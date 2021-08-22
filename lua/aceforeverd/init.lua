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

local set_map = vim.api.nvim_set_keymap

-- keep vim default maps
set_map('x', ']"', '"', { noremap = true, silent = true })
set_map('n', '{{', '{', { noremap = true, silent = true })
set_map('n', '}}', '}', { noremap = true, silent = true })

vim.api.nvim_exec([[
    call coc#config('clangd.semanticHighlighting', v:false)
    call coc#config('Lua.workspace.library', {$VIMRUNTIME . '/lua': v:true})
    call coc#config('Lua.diagnostics.globals', ['vim'])

    let g:matchup_matchparen_offscreen = {}
]], false)

-- colorsscheme
vim.g.material_style = 'darker'
vim.g.material_borders = true
vim.g.material_variable_color = '#3adbc5'
vim.api.nvim_set_keymap('n', [[<space>n]],
                        [[<Cmd>lua require('material.functions').toggle_style()<CR>]],
                        { noremap = true, silent = true })
require('material').set()
