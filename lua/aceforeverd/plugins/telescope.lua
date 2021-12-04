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
local telescope = require('telescope')

telescope.setup {
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
      show_unindexed = false,
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case" -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    project = { base_dirs = { '~/Git' } }
  }
}

telescope.load_extension('fzf')

-- telescope-frecency
telescope.load_extension("frecency")

local set_map = vim.api.nvim_set_keymap

set_map('n', '<Leader>fl', '<Cmd>Telescope<CR>', { noremap = true, silent = false })

set_map('n', '<leader>fo', '<cmd>lua require("telescope").extensions.repo.list{}<cr>',
        { noremap = true, silent = true })

set_map("n", "<leader>fr", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
        { noremap = true, silent = true })
set_map("n", "<leader>ff", "<Cmd>lua require('telescope.builtin').find_files()<CR>",
        { noremap = true, silent = true })

set_map('n', '<Leader>fp', "<Cmd>lua require('telescope').extensions.packer.plugins()<CR>",
        { noremap = true, silent = true })

set_map('n', '<Leader>fj', "<Cmd>lua require'telescope'.extensions.project.project{}<CR>",
        { noremap = true, silent = true })
set_map('n', '<Leader>fs', "<Cmd>lua require'telescope'.extensions.projects.projects{}<CR>",
        { noremap = true, silent = true })

set_map('n', '<Leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>",
        { noremap = true, silent = true })

set_map('n', '<Leader>fu', "<cmd>lua require'telescope'.extensions.ultisnips.ultisnips{}<cr>",
        { noremap = true, silent = true })
