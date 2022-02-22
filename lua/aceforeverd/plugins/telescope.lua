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

  local tel_map_list = {
    ['<leader>f'] = {
      ['F'] = '<cmd>Telescope<CR>',
      ['f'] = [[<Cmd>lua require('telescope.builtin').find_files()<CR>]],
      ['b'] = "<cmd>lua require('telescope.builtin').buffers()<cr>",
      ['c'] = "<cmd>lua require('telescope.builtin').commands()<cr>",
      ['e'] = '<Cmd>Telescope grep_string<CR>',
      ['gf'] = '<Cmd>Telescope git_files<CR>',
      ['gs'] = '<cmd>Telescope git_status<cr>',
      ['gb'] = '<cmd>Telescope git_branches<cr>',
      ['s'] = [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]],
      ['o'] = [[<cmd>lua require("telescope").extensions.repo.list{}<cr>]],
      ['r'] = [[<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>]],
      ['x'] = [[<Cmd>lua require('telescope').extensions.packer.packer()<CR>]],
      ['p'] = [[<Cmd>lua require'telescope'.extensions.project.project{}<CR>]],
      ['j'] = [[<Cmd>lua require'telescope'.extensions.projects.projects{}<CR>]],

      ['I'] = "<cmd>lua require'telescope'.extensions.gh.issues()<cr>",
      ['P'] = "<cmd>lua require'telescope'.extensions.gh.pull_request()<cr>",
      ['R'] = "<cmd>lua require'telescope'.extensions.gh.run()<cr>",
      ['G'] = "<cmd>lua require'telescope'.extensions.gh.gist()<cr>",

      ['z'] = '<cmd>lua require"telescope".extensions.zoxide.list{}<cr>',
      ['l'] = [[<cmd>lua require"telescope".extensions.file_browser.file_browser()<cr>]],
      ['E'] = [[<cmd>lua require('telescope').extensions.env.env{}<cr>]],
    },
  }

  local function do_map(prefix, map_list)
    if type(prefix) ~= 'string' then
      vim.api.nvim_notify('[skip]: prefix is not string', vim.log.levels.WARN, {})
    end

    if type(map_list) == 'table' then
      for key, value in pairs(map_list) do
        do_map(prefix .. key, value)
      end
    elseif type(map_list) == 'string' then
      vim.api.nvim_set_keymap('n', prefix, map_list, map_opts)
    else
      vim.api.nvim_notify('[skip]: map_list is not table', vim.log.levels.WARN, {})
    end
  end

  do_map('', tel_map_list)
end

return M
