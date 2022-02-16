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

function M.setup()
  local telescope = require('telescope')

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-j>'] = require('telescope.actions').move_selection_next,
          ['<C-k>'] = require('telescope.actions').move_selection_previous,
        },
      },
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
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  })

  telescope.load_extension('fzf')

  -- telescope-frecency
  telescope.load_extension('frecency')

  local map_opts = { noremap = true, silent = false }

  local set_map = vim.api.nvim_set_keymap

  set_map('n', '<Leader>F', '<Cmd>Telescope<CR>', map_opts)
  set_map('n', '<Leader>fe', '<Cmd>Telescope grep_string<CR>', map_opts)

  set_map('n', '<Leader>fgf', '<Cmd>Telescope git_files<CR>', map_opts)
  set_map('n', '<Leader>fgs', '<Cmd>Telescope git_status<CR>', map_opts)
  set_map('n', '<Leader>fgb', '<Cmd>Telescope git_branches<CR>', map_opts)

  set_map('n', '<Leader>fs', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]], map_opts)

  set_map(
    'n',
    '<leader>fo',
    '<cmd>lua require("telescope").extensions.repo.list{}<cr>',
    { noremap = true, silent = true }
  )

  set_map(
    'n',
    '<leader>fr',
    "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
    { noremap = true, silent = true }
  )
  set_map(
    'n',
    '<leader>ff',
    "<Cmd>lua require('telescope.builtin').find_files()<CR>",
    { noremap = true, silent = true }
  )

  set_map(
    'n',
    '<Leader>fx',
    "<Cmd>lua require('telescope').extensions.packer.packer()<CR>",
    { noremap = true, silent = true }
  )

  set_map(
    'n',
    '<Leader>fp',
    "<Cmd>lua require'telescope'.extensions.project.project{}<CR>",
    { noremap = true, silent = true }
  )

  set_map(
    'n',
    '<Leader>fj',
    "<Cmd>lua require'telescope'.extensions.projects.projects{}<CR>",
    { noremap = true, silent = true }
  )

  set_map('n', '<Leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true, silent = true })

  set_map(
    'n',
    '<Leader>fu',
    "<cmd>lua require'telescope'.extensions.ultisnips.ultisnips{}<cr>",
    { noremap = true, silent = true }
  )

  set_map(
    'n',
    '<Leader>fI',
    "<cmd>lua require'telescope'.extensions.gh.issues()<cr>",
    { noremap = true, silent = true }
  )
  set_map(
    'n',
    '<Leader>fP',
    "<cmd>lua require'telescope'.extensions.gh.pull_request()<cr>",
    { noremap = true, silent = true }
  )
  set_map('n', '<Leader>fR', "<cmd>lua require'telescope'.extensions.gh.run()<cr>", { noremap = true, silent = true })
  set_map('n', '<Leader>fG', "<cmd>lua require'telescope'.extensions.gh.gist()<cr>", { noremap = true, silent = true })

  set_map('n', '<Leader>fz', '<cmd>lua require"telescope".extensions.zoxide.list{}<cr>', map_opts)
  set_map('n', '<Leader>fl', [[<cmd>lua require"telescope".extensions.file_browser.file_browser()<cr>]], map_opts)
end

return M
