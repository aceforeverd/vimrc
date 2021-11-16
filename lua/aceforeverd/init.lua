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
    let g:matchup_matchparen_offscreen = {}
]], false)

-- sonokai link 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' default to 'CurrentWord'
-- for lsp enabled buffer, 'Lspreference*' groups are used
-- NOTE: do not put it in plugin settings, it should be sourced before colorscheme action
vim.cmd([[augroup gp_lsp
autocmd!
autocmd ColorScheme * highlight LspReferenceText cterm=bold gui=bold guibg=#5e5e5f
autocmd ColorScheme * highlight LspReferenceRead cterm=underline gui=undercurl guibg=#5e5e5f
autocmd ColorScheme * highlight LspReferenceWrite cterm=bold,underline gui=bold,undercurl guibg=#5e5e9f
augroup END]])

vim.cmd[[
augroup gp_illuminate_highlight
autocmd!
autocmd ColorScheme * highlight illuminatedWord guibg=#5e5e5e
autocmd ColorScheme * highlight illuminatedCurWord guibg=#5e5e8f
augroup END]]
