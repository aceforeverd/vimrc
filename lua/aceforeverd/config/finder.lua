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

function M.telescope()
  local telescope = require('telescope')

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-j>'] = require('telescope.actions').move_selection_next,
          ['<C-k>'] = require('telescope.actions').move_selection_previous,
          ['<C-e>'] = { '<END>', type = 'command' },
          ['<C-/>'] = require('telescope.actions.generate').which_key({}),
          ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
          ['<c-n>'] = false, -- resevered key
          -- disabled for conflicts with builtin mapping in some commands
          -- ['<C-l>'] = require('telescope.actions.layout').cycle_layout_next,
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
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  })

  telescope.load_extension('fzf')

  -- telescope-frecency
  telescope.load_extension('frecency')

  local map_opts = { noremap = true, silent = false }

  local tel_map_list = {
    ['<space>'] = {
      ['<space>'] = [[<cmd>Telescope<CR>]],
      ['b'] = {
        function()
          require('telescope.builtin').buffers()
        end,
        { desc = 'buffers' },
      },
      ['c'] = {
        function()
          require('telescope.builtin').commands()
        end,
        { desc = 'commands' },
      },
      ['R'] = {
        function()
          require('telescope.builtin').live_grep({})
        end,
        { desc = 'live grep' },
      },
    },
    ['<leader>f'] = {
      -- general case
      ['f'] = {
        function()
          require('telescope.builtin').find_files()
        end,
        { desc = 'find file' },
      },
      ['e'] = {
        function()
          require('telescope.builtin').grep_string({})
        end,
        { desc = 'grep string' },
      },
      ['s'] = {
        function()
          require('telescope.builtin').spell_suggest()
        end,
        { desc = 'spell suggest' },
      },
      ['o'] = {
        function()
          require('telescope').extensions.repo.list({})
        end,
        { desc = 'list repos' },
      },
      ['r'] = {
        function()
          require('telescope').extensions.frecency.frecency()
        end,
        { desc = 'frecency' },
      },
      ['j'] = {
        function()
          require('telescope').extensions.projects.projects({})
        end,
        { desc = 'list projects' },
      },

      ['I'] = {
        function()
          require('telescope').extensions.gh.issues()
        end,
        { desc = 'gh issues' },
      },
      ['P'] = {
        function()
          require('telescope').extensions.gh.pull_request()
        end,
        { desc = 'gh PRs' },
      },
      ['R'] = {
        function()
          require('telescope').extensions.gh.run()
        end,
        { desc = 'gh workflow run' },
      },
      ['G'] = {
        function()
          require('telescope').extensions.gh.gist()
        end,
        { desc = 'gh gists' },
      },

      ['z'] = {
        function()
          require('telescope').extensions.zoxide.list({})
        end,
        { desc = 'zoxide list' },
      },
      ['l'] = {
        function()
          require('telescope').extensions.file_browser.file_browser()
        end,
        { desc = 'file browse' },
      },
    },
    ['<leader>q'] = {
      f = { '<cmd>FzfLua quickfix<cr>', { desc = 'quickfix fzflua' } },
      t = { '<cmd>Telescope quickfix<cr>', { desc = 'quickfix telescope' } },
      b = { '<cmd>Trouble quickfix<cr>', { desc = 'quickfix trouble' } },
    },
    ['<leader>l'] = {
      -- lsp
      ['s'] = {
        function()
          require('telescope.builtin').lsp_document_symbols()
        end,
        { desc = 'lsp document symbols [telescope]' },
      },
      ['S'] = {
        function()
          require('telescope.builtin').lsp_workspace_symbols()
        end,
        { desc = 'lsp workspace symbols [telescope]' },
      },
    },
    ['<leader>g'] = {
      -- git ops
      ['f'] = { '<Cmd>Telescope git_files<CR>', { desc = 'git files' } },
      ['s'] = { '<cmd>Telescope git_status<cr>', { desc = 'git status' } },
      ['S'] = { '<cmd>Telescope git_stash<cr>', { desc = 'git stash' } },
      ['C'] = { '<cmd>Telescope git_commits<cr>', { desc = 'git commits' } },
      ['c'] = { '<cmd>Telescope git_bcommits<cr>', { desc = 'git buf-local commits' } },
      ['x'] = { '<cmd>Telescope git_branches<cr>', { desc = 'git branches' } },
    },
  }

  require('aceforeverd.util.map').do_map({ ['n'] = tel_map_list }, map_opts)
end

return M
