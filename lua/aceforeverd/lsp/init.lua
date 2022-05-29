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
    vim.g.loaded_cmp = true
    return
  end

  -- basic settings
  vim.o.pumblend = 20

  if vim.g.lsp_process_provider == 'lsp_status' then
    require('lsp-status').register_progress()
  elseif vim.g.lsp_process_provider == 'fidget' then
    require('fidget').setup({})
  end

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

  -- Show line diagnostics automatically in hover window
  --  disabled: should only show if cursor is in the `DiagnosticUnderline*` text.
  -- vim.cmd [[
  -- augroup gp_nvim_lsp_customize
  -- autocmd!
  -- autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})
  -- augroup END
  -- ]]

  -- setup lsp installer just before other lsp configurations
  -- so they will inherit lsp-insatller settings, like pickup the correct lsp program
  require('aceforeverd.lsp.installer').setup()

  M.clangd()

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
      vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        '<Leader>af',
        '<cmd>ClangdSwitchSourceHeader<cr>',
        { noremap = true, silent = true }
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

function M.go()
  -- :GoInstallBinaries
  require('go').setup({
    lsp_cfg = false,
  })

  local opts = vim.tbl_deep_extend('force', require('go.lsp').config(), require('aceforeverd.lsp.common').general_cfg)
  require('lspconfig').gopls.setup(opts)
end

function M.zk()
  require('zk').setup({
    picker = 'telescope',
    lsp = require('aceforeverd.lsp.common').general_cfg,
  })
end

function M.rust_analyzer()
  require('rust-tools').setup({
    server = require('aceforeverd.lsp.common').general_cfg,
  })
end

return M
