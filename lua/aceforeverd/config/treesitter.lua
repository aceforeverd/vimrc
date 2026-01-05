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

-- TODO: prompt install parser lazily if it not installed for current filetype ?
local function selected_ts_langs()
  local langs = require('nvim-treesitter').get_available()
end

-- new setup entry for nvim-treesitter on main branch
function M.setup_next()
  -- NOTE: require tree-sitter-cli exists on $PATH
  --  run: cargo install --locked tree-sitter-cli
  require('nvim-treesitter').setup({
    -- Directory to install parsers and queries to
    install_dir = vim.fn.stdpath('data') .. '/site',
  })

  -- highlight, :help treesitter-highlight
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function(args)
      local installed = require('nvim-treesitter').get_installed()
      if vim.tbl_contains(installed, vim.bo[args.buf].filetype) == true then
        vim.treesitter.start(args.buf)

        -- only if additional legacy syntax is needed
        -- vim.bo[args.buf].syntax = 'on'

        -- folds
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end
    end,
  })

  --
  -- indent
  -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

--- deprecated
function M.setup()
  local hi_disable_fts = { 'yaml', 'coc-explorer', 'cmake' }
  local hi_max_filesize = 100 * 1024 -- 100 KB
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    ignore_install = {
      -- https://github.com/alemuller/tree-sitter-make not active ?
      'make',
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/8029
      'ipkg',
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        if vim.tbl_contains(hi_disable_fts, lang) then
          return true
        end
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > hi_max_filesize then
          return true
        end
        return false
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { 'yaml' } },
    incremental_selection = {
      enable = false,
    },
    matchup = { enable = true },
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
  })

  -- :set foldmethod=expr to enable fold with expr, default is manual
  vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])
end

function M.textobj()
  require('nvim-treesitter-textobjects').setup({
    select = {
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise

        -- ['af'] = '@function.outer',
        -- ['if'] = '@function.inner',
        -- ['ac'] = '@class.outer',
        -- ['ic'] = '@class.inner',
        -- ['ar'] = '@parameter.outer',
        -- ['ir'] = '@parameter.inner',
        -- ['ak'] = '@block.outer',
        -- ['ik'] = '@block.inner',
        -- ['a;'] = '@statement.outer',
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },

    move = {
      -- whether to set jumps in the jumplist
      set_jumps = true,
    },
  })

  -- swap
  vim.keymap.set('n', '<M-l>', function()
    require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
  end)
  vim.keymap.set('n', '<M-h>', function()
    require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
  end)

  -- moves
  local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
end

return M
