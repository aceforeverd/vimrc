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


local M = {}

function M.before_load()
    vim.g.clap_enable_yanks_provider = 1
    vim.g.clap_provider_yanks_history = vim.fn.stdpath('data') .. '/clap_yanks_history'
end

function M.setup()
    vim.api.nvim_set_keymap('n', '<leader>cl', ':Clap<cr>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>cf', ':Clap files<cr>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>cb', ':Clap buffers<cr>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Space>l', ':Clap yanks<cr>', {noremap = true, silent = true})
end

return M
