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

local M = {}

function M.setup()
  vim.g.loaded_endwise = 1
  -- treesitter removes xml, fallback to tagalong
  -- TODO: udpate the list where nvim-ts-autotag not support
  vim.g.tagalong_filetypes = { 'xml' }

  local hi_disable_fts = { 'yaml', 'coc-explorer', 'cmake' }
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    ignore_install = {
      -- https://github.com/alemuller/tree-sitter-make not active ?
      'make',
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        if vim.tbl_contains(hi_disable_fts, lang) then
          return true
        end
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        return false
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { 'yaml' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<space>n',
        node_incremental = 'go',
        node_decremental = 'gi',
        scope_incremental = 'gu',
      },
    },
    matchup = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
    playground = {
      enable = false,
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
        show_help = '?',
      },
    },
    refactor = {
      highlight_definitions = { enable = false },
      highlight_current_scope = { enable = false },
      smart_rename = { enable = true, keymaps = { smart_rename = '<Leader>rt' } },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = '<space>gl',
          list_definitions = '<space>gL',
          list_definitions_toc = 'gO',
          goto_next_usage = '<a-*>',
          goto_previous_usage = '<a-#>',
        },
      },
    },
    textobjects = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- ']' -> next, '[' -> previous,
        -- lowercase -> next/previous start, uppercase -> next/previous end
        goto_next_start = { -- ']'
          ['}k'] = '@block.inner',
          [']k'] = '@block.outer',
          ['}g'] = '@call.inner',
          [']g'] = '@call.outer',
          ['}]'] = '@class.inner',
          [']]'] = '@class.outer',
          [']/'] = '@comment.outer',
          ['}j'] = '@conditional.inner',
          [']j'] = '@conditional.outer',
          ['}m'] = '@function.inner',
          [']m'] = '@function.outer',
          ['}w'] = '@loop.inner',
          [']w'] = '@loop.outer',
          ['}r'] = '@parameter.inner',
          [']r'] = '@parameter.outer',
          ['];'] = '@statement.outer',
        },
        goto_next_end = { -- '>'
          ['}K'] = '@block.inner',
          [']K'] = '@block.outer',
          ['}G'] = '@call.inner',
          [']G'] = '@call.outer',
          ['}['] = '@class.inner',
          [']['] = '@class.outer',
          ['}/'] = '@comment.outer',
          ['}J'] = '@conditional.inner',
          [']J'] = '@conditional.outer',
          ['}M'] = '@function.inner',
          [']M'] = '@function.outer',
          ['}W'] = '@loop.inner',
          [']W'] = '@loop.outer',
          ['}R'] = '@parameter.inner',
          [']R'] = '@parameter.outer',
          ['};'] = '@statement.outer',
        },
        goto_previous_start = { -- '['
          ['{k'] = '@block.inner',
          ['[k'] = '@block.outer',
          ['{g'] = '@call.inner',
          ['[g'] = '@call.outer',
          ['{['] = '@class.inner',
          ['[['] = '@class.outer',
          ['[/'] = '@comment.outer',
          ['{j'] = '@conditional.inner',
          ['[j'] = '@conditional.outer',
          ['{m'] = '@function.inner',
          ['[m'] = '@function.outer',
          ['{w'] = '@loop.inner',
          ['[w'] = '@loop.outer',
          ['{r'] = '@parameter.inner',
          ['[r'] = '@parameter.outer',
          ['[;'] = '@statement.outer',
        },
        goto_previous_end = { -- '<'
          ['{K'] = '@block.inner',
          ['[K'] = '@block.outer',
          ['{G'] = '@call.inner',
          ['[G'] = '@call.outer',
          ['{]'] = '@class.inner',
          ['[]'] = '@class.outer',
          ['{/'] = '@comment.outer',
          ['{J'] = '@conditional.inner',
          ['[J'] = '@conditional.outer',
          ['{M'] = '@function.inner',
          ['[M'] = '@function.outer',
          ['{W'] = '@loop.inner',
          ['[W'] = '@loop.outer',
          ['{R'] = '@parameter.inner',
          ['[R'] = '@parameter.outer',
          ['{;'] = '@statement.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<M-l>'] = '@parameter.inner',
        },
        swap_previous = {
          ['<M-h>'] = '@parameter.inner',
        },
      },
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['ar'] = '@parameter.outer',
          ['ir'] = '@parameter.inner',
          ['ak'] = '@block.outer',
          ['ik'] = '@block.inner',
          ['a;'] = '@statement.outer',
        },
      },
      lsp_interop = {
        enable = true,
        border = 'none',
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dF'] = '@class.outer',
        },
      },
    },
    textsubjects = {
      enable = true,
      prev_selection = ',',
      keymaps = {
        -- omap
        ['.'] = 'textsubjects-smart',
        ['a.'] = 'textsubjects-container-outer',
        ['i.'] = 'textsubjects-container-inner',
      },
    },
    endwise = {
      enable = true,
    },
    context_commentstring = { enable = true, enable_autocmd = false },
    autotag = {
      enable = true,
    },
  })

  -- :set foldmethod=expr to enable fold with expr, default is manual
  vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])
  require('aceforeverd.util.map').set_map(
    'n',
    '<leader>uc',
    ":lua require('ts_context_commentstring.internal').update_commentstring()<CR>",
    { silent = true, noremap = true }
  )
end

return M
