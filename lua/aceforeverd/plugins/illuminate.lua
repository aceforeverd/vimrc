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

-- sonokai link 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' default to 'CurrentWord'
-- for lsp enabled buffer, 'Lspreference*' groups are used
-- otherwise, 'illuminate*' groups are used
vim.api.nvim_exec([[
augroup illuminate_augroup
autocmd!
autocmd VimEnter * highlight illuminatedWord cterm=underline guibg=#5e5e5e gui=underline
autocmd VimEnter * highlight illuminatedCurWord cterm=bold,underline guibg=#5e5e8f gui=bold,underline

autocmd VimEnter * highlight LspReferenceText guibg=#5e5e5f
autocmd VimEnter * highlight LspReferenceRead cterm=underline gui=underline guibg=#5e5e6f
autocmd VimEnter * highlight LspReferenceWrite cterm=bold gui=bold guibg=#5e5e9f
augroup END]], false)

vim.g.Illuminate_delay = vim.o.updatetime

vim.api.nvim_set_keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<a-i>', '<cmd>lua require"illuminate".toggle_pause()<cr>', {noremap=true})
