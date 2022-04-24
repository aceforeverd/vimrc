-- Copyright (C) 2022  Ace <teapot@aceforeverd.com>
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

local dash_cfg = {
  -- https://github.com/mrjones2014/dash.nvim#configuration-table-structure
  file_type_keywords = {
    c = { 'c', 'clang', 'llvm', 'gdb' },
    cpp = { 'cpp', 'clang', 'llvm', 'gdb' },
  }
}

function M.fzflua()
  require('fzf-lua').setup({ winopts = { width = 0.9 } })
end

function M.dash()
  require('dash').setup(dash_cfg)

  require('aceforeverd.utility.map').set_map('n', '<space>D', '<cmd>Dash<cr>', {})
end

function M.telescope()
  local telescope = require('telescope')

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-j>'] = require('telescope.actions').move_selection_next,
          ['<C-k>'] = require('telescope.actions').move_selection_previous,
          ['<C-e>'] = { '<END>', type = 'command' },
          ['<C-/>'] = require('telescope.actions.generate').which_key,
          ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
          ['<c-n>'] = false,
          ['<C-l>'] = require('telescope.actions.layout').cycle_layout_next,
          ['<C-h>'] = require('telescope.actions.layout').cycle_layout_prev,
          ['<C-i>'] = require('telescope.actions.layout').toggle_prompt_position,
          ['<C-]>'] = require('telescope.actions.layout').toggle_mirror,
        },
      },
      layout_strategies = 'flex',
      layout_config = {
        horizontal = { width = 0.95 },
      },
      winblend = 10,
      prompt_prefix = [[> ]],
      selection_caret = [[> ]],
      entry_prefix = [[  ]],
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
      dash = dash_cfg,
    },
  })

  telescope.load_extension('fzf')

  -- telescope-frecency
  telescope.load_extension('frecency')

  local map_opts = { noremap = true, silent = false }

  local tel_map_list = {
    ['<space>'] = {
      ['<space>'] = [[<cmd>Telescope<CR>]],
      ['b'] = "<cmd>lua require('telescope.builtin').buffers()<cr>",
      ['c'] = "<cmd>lua require('telescope.builtin').commands()<cr>",
      ['g'] = [[<cmd>lua require('telescope.builtin').live_grep{}<cr>]],
    },
    ['<leader>f'] = {
      ['f'] = [[<Cmd>lua require('telescope.builtin').find_files()<CR>]],
      ['e'] = [[<Cmd>lua require('telescope.builtin').grep_string{}<CR>]],
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
    ['<leader>g'] = {
      ['f'] = '<Cmd>Telescope git_files<CR>',
      ['s'] = '<cmd>Telescope git_status<cr>',
      ['S'] = '<cmd>Telescope git_stash<cr>',
      ['C'] = '<cmd>Telescope git_commits<cr>',
      ['c'] = '<cmd>Telescope git_bcommits<cr>',
      ['x'] = '<cmd>Telescope git_branches<cr>',
    },
  }

  require('aceforeverd.utility.map').do_map({ ['n'] = tel_map_list }, map_opts)
end

return M
