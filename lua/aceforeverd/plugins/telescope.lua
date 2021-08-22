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
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous
      }
    }
  },
  extensions = {
    frecency = {
      show_scores = true,
      show_unindexed = true,
      workspaces = { ["openmldb"] = "/Users/danielace/Git/4paradigm/OpenMLDB" }
    }
  }
}

vim.api.nvim_set_keymap("n", "<leader>tf",
                        "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
                        { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tl', '<Cmd>Telescope<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Leader>tp',
                        "<Cmd>lua require('telescope').extensions.packer.plugins()<CR>",
                        { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tj',
                        "<Cmd>lua require'telescope'.extensions.project.project{}<CR>",
                        { noremap = true, silent = true })
