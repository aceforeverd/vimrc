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

vim.g.material_style = 'darker'
vim.g.material_borders = true
vim.g.material_variable_color = '#3adbc5'
require('material').set()

set_map('n', '<c-n>', [[<Cmd>lua require('material.functions').toggle_style()<CR>]],
        { noremap = true, silent = true })

set_map('n', '<Space>r', [[ <Cmd>lua require 'nvim-tree'.toggle()<CR> ]],
        { noremap = true, silent = false })

set_map('n', '{{', '{', { noremap = true, silent = true })
set_map('n', '}}', '}', { noremap = true, silent = true })

local treesitter_config = require('nvim-treesitter.configs')
treesitter_config.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { 'yaml' } -- list of language that will be disabled
  },
  indent = { enable = true, disable = { 'yaml' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  matchup = { enable = true },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" }
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?'
    }
  },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true, disable = { 'c', 'cpp', 'yaml' } },
    smart_rename = { enable = true, keymaps = { smart_rename = "<Leader>rt" } },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>"
      }
    }
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      -- ']' -> next, '[' -> previous,
      -- lowercase -> next/previous start, uppercase -> next/previous end
      goto_next_start = { -- ']'
        ["}k"] = "@block.inner",
        ["]k"] = "@block.outer",
        ["}g"] = "@call.inner",
        ["]g"] = "@call.outer",
        ["}]"] = "@class.inner",
        ["]]"] = "@class.outer",
        ["]/"] = "@comment.outer",
        ["}j"] = "@conditional.inner",
        ["]j"] = "@conditional.outer",
        ["}m"] = "@function.inner",
        ["]m"] = "@function.outer",
        ["}w"] = "@loop.inner",
        ["]w"] = "@loop.outer",
        ["}r"] = "@parameter.inner",
        ["]r"] = "@parameter.outer",
        ["];"] = "@statement.outer"
      },
      goto_next_end = { -- '>'
        ["}K"] = "@block.inner",
        ["]K"] = "@block.outer",
        ["}G"] = "@call.inner",
        ["]G"] = "@call.outer",
        ["}["] = "@class.inner",
        ["]["] = "@class.outer",
        ["}/"] = "@comment.outer",
        ["}J"] = "@conditional.inner",
        ["]J"] = "@conditional.outer",
        ["}M"] = "@function.inner",
        ["]M"] = "@function.outer",
        ["}W"] = "@loop.inner",
        ["]W"] = "@loop.outer",
        ["}R"] = "@parameter.inner",
        ["]R"] = "@parameter.outer",
        ["};"] = "@statement.outer"
      },
      goto_previous_start = { -- '['
        ["{k"] = "@block.inner",
        ["[k"] = "@block.outer",
        ["{g"] = "@call.inner",
        ["[g"] = "@call.outer",
        ["{["] = "@class.inner",
        ["[["] = "@class.outer",
        ["[/"] = "@comment.outer",
        ["{j"] = "@conditional.inner",
        ["[j"] = "@conditional.outer",
        ["{m"] = "@function.inner",
        ["[m"] = "@function.outer",
        ["{w"] = "@loop.inner",
        ["[w"] = "@loop.outer",
        ["{r"] = "@parameter.inner",
        ["[r"] = "@parameter.outer",
        ["[;"] = "@statement.outer"
      },
      goto_previous_end = { -- '<'
        ["{K"] = "@block.inner",
        ["[K"] = "@block.outer",
        ["{G"] = "@call.inner",
        ["[G"] = "@call.outer",
        ["{]"] = "@class.inner",
        ["[]"] = "@class.outer",
        ["{/"] = "@comment.outer",
        ["{J"] = "@conditional.inner",
        ["[J"] = "@conditional.outer",
        ["{M"] = "@function.inner",
        ["[M"] = "@function.outer",
        ["{W"] = "@loop.inner",
        ["[W"] = "@loop.outer",
        ["{R"] = "@parameter.inner",
        ["[R"] = "@parameter.outer",
        ["{;"] = "@statement.outer"
      }
    }
  }
}
