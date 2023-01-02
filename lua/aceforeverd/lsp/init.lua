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
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

local M = {}

local lsp_basic = require('aceforeverd.lsp.common')

function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  if vim.fn.has('mac') ~= 1 and vim.fn.has('unix') ~= 1 then
    vim.api.nvim_notify('Unsupported system', 3, {})
    return
  end

  -- basic settings
  vim.o.pumblend = 20

  require('aceforeverd.lsp.common').diagnostics_config()

  if vim.g.lsp_process_provider == 'lsp_status' then
    require('lsp-status').register_progress()
  elseif vim.g.lsp_process_provider == 'fidget' then
    require('fidget').setup({})
  end

  -- setup lsp installer just before other lsp configurations
  -- so they will inherit lsp-insatller settings, picking up the correct lsp program
  require('aceforeverd.lsp.installer').setup()

  local cfgs = require('aceforeverd.lsp.servers')
  for name, fn in pairs(cfgs) do
    fn(name)
  end

  M.clangd()
  require('aceforeverd.lsp.jdtls').setup()
  require('aceforeverd.lsp.metals').metals()
  M.hls()
end

function M.clangd()
  local on_attach = lsp_basic.on_attach
  local capabilities = lsp_basic.capabilities

  local clangd_caps = vim.tbl_deep_extend('force', capabilities, {
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
    offsetEncoding = { 'utf-16' },
  })

  local clangd_cfg = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.keymap.set(
        'n',
        '<Leader>af',
        '<cmd>ClangdSwitchSourceHeader<cr>',
        { noremap = true, silent = true, buffer = bufnr }
      )
    end,
    capabilities = clangd_caps,
    handlers = vim.tbl_deep_extend('error', lsp_basic.handlers, require('lsp-status').extensions.clangd.setup()),
    init_options = { clangdFileStatus = true },
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--all-scopes-completion',
      -- '--inlay-hints',
    },
  }

  require('clangd_extensions').setup({
    server = clangd_cfg,
  })
end

function M.lsp_status()
  local lsp_status = require('lsp-status')
  local lsp_status_diagnostic_enable = vim.g.my_statusline == 'lightline'
  lsp_status.config({
    select_symbol = function(cursor_pos, symbol)
      if symbol.valueRange then
        local value_range = {
          ['start'] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
          ['end'] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) },
        }

        return require('lsp-status.util').in_range(cursor_pos, value_range)
      end
    end,
    current_function = false,
    show_filename = false,
    status_symbol = '🐶',
    diagnostics = lsp_status_diagnostic_enable,
  })
end

function M.lspkind()
  require('lspkind').init({
    mode = 'symbol_text',
  })
end

function M.inc_rename()
  require("inc_rename").setup()
  vim.keymap.set('n', '<leader>ri', ':<C-u>IncRename ', {})
end

function M.go()
  -- :GoInstallBinaries
  require('go').setup({
    lsp_cfg = require('aceforeverd.lsp.common').general_cfg,
    textobjects = false,
    lsp_keymaps = false,
  })
end

function M.rust_analyzer()
  require('rust-tools').setup({
    server = require('aceforeverd.lsp.common').general_cfg,
  })
end

function M.hls()
  require('haskell-tools').setup({
    hls = lsp_basic.general_cfg
  })
end

return M
