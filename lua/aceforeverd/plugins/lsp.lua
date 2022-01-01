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
if vim.g.my_cmp_source ~= 'nvim_lsp' then
  vim.g.loaded_cmp = true
  return
end

-- basic settings
vim.o.pumblend = 20

local lspconfig = require('lspconfig')
local lsp_basic = require('aceforeverd.config.lsp-basic')
local on_attach = lsp_basic.on_attach
local capabilities = lsp_basic.capabilities

local lsp_status = require('lsp-status')
local lsp_status_diagnostic_enable = vim.g.my_cmp_source == 'lightline'
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
lsp_status.register_progress()

local signs = {}
local group = 'LspDiagnosticsSign'
if vim.fn.has('nvim-0.6.0') == 1 then
  group = 'DiagnosticSign'
  signs = vim.tbl_extend('force', signs, { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' })
else
  signs = vim.tbl_extend('force', signs, { Error = ' ', Warning = ' ', Hint = ' ', Information = ' ' })
end

for type, icon in pairs(signs) do
  local hl = group .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local pub_diag_config = { virtual_text = true, signs = true, underline = true, update_in_insert = false }
if vim.fn.has('nvim-0.6.0') == 1 then
  pub_diag_config['virtual_text'] = {
    prefix = '😡', -- Could be '●', '▎', 'x'
    source = 'always',
  }
  pub_diag_config['float'] = { source = 'always' }
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  pub_diag_config
)

-- Show line diagnostics automatically in hover window
--  disabled: should only show if cursor is in the `DiagnosticUnderline*` text.
-- vim.cmd [[
-- augroup gp_nvim_lsp_customize
-- autocmd!
-- autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})
-- augroup END
-- ]]

local default_lsp_cfg = { on_attach = on_attach, capabilities = capabilities }

lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      'n',
      '<Leader>af',
      '<cmd>ClangdSwitchSourceHeader<cr>',
      { noremap = true, silent = true }
    )
  end,
  capabilities = capabilities,
  handlers = require('lsp-status').extensions.clangd.setup(),
  init_options = { clangdFileStatus = true },
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--cross-file-rename',
    '--all-scopes-completion',
    '--suggest-missing-includes',
  },
})

-- go install golang.org/x/tools/gopls@latest or :GoInstallBinaries
lspconfig.gopls.setup(default_lsp_cfg)

