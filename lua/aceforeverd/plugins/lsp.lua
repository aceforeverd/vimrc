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

-- npm install -g vim-language-server
lspconfig.vimls.setup(default_lsp_cfg)
-- npm install -g pyright
lspconfig.pyright.setup(default_lsp_cfg)
-- npm install -g typescript typescript-language-server
lspconfig.tsserver.setup(default_lsp_cfg)

-- go install golang.org/x/tools/gopls@latest or :GoInstallBinaries
lspconfig.gopls.setup(default_lsp_cfg)
-- npm install -g dockerfile-language-server-nodejs
lspconfig.dockerls.setup(default_lsp_cfg)
-- npm install -g yaml-language-server
lspconfig.yamlls.setup(vim.tbl_deep_extend('keep', default_lsp_cfg, {
  settings = {
    yaml = {
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
      },
    },
  },
}))

-- install via 'npm i -g vscode-langservers-extracted'
local html_addtional_cap = { textDocument = { completion = { completionItem = { snippetSupport = true } } } }
local html_cfg = vim.tbl_deep_extend('force', default_lsp_cfg, { capabilities = html_addtional_cap })
lspconfig.html.setup(html_cfg)
lspconfig.cssls.setup(html_cfg)

lspconfig.jsonls.setup(vim.tbl_deep_extend('keep', html_cfg, {
  commands = {
    JsonFormat = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
      end,
    },
  },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}))

-- npm install -g @tailwindcss/language-server
lspconfig.tailwindcss.setup(default_lsp_cfg)

lspconfig.diagnosticls.setup(vim.tbl_deep_extend('keep', default_lsp_cfg, {
  filetypes = { 'cpp', 'yaml', 'sh', 'vim' },
  init_options = {
    linters = {
      vint = {
        command = "vint",
        debounce = 100,
        args = {"--enable-neovim", "--no-color", "-"},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = "vint",
        formatLines = 1,
        formatPattern = {
          "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
          {
            line = 1,
            column = 2,
            message = 3
          }
        }
      },
      cpplint = {
        command = 'cpplint',
        args = { '%file' },
        debounce = 100,
        isStderr = true,
        isStdout = false,
        sourceName = 'cpplint',
        offsetLine = 0,
        offsetColumn = 0,
        formatPattern = {
          '^[^:]+:(\\d+):(\\d+)?\\s+(.+?)\\s\\[(\\d)\\]$',
          {
            line = 1,
            column = 2,
            message = 3,
            security = 4,
          },
        },
        securities = {
          [1] = 'info',
          [2] = 'warning',
          [3] = 'warning',
          [4] = 'warning',
          [5] = 'error',
        },
      },
      shellcheck = {
        command = 'shellcheck',
        debounce = 100,
        args = {
          '--format',
          'json',
          '-',
        },
        sourceName = 'shellcheck',
        parseJson = {
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '${message} [${code}]',
          security = 'level',
        },
        securities = {
          error = 'error',
          warning = 'warning',
          info = 'info',
          style = 'hint',
        },
      },
      actionlint = {
        command = 'actionlint',
        args = { '%file' },
        sourceName = 'actionlint',
        rootPatterns = { '.github' },
        ignore = { '/*', '!/.github', '/.github/*', '!/.github/workflows' },
        formatPattern = {
          '^[^:]+:(\\d+):(\\d+):\\s+(.+)$',
          {
            line = 1,
            column = 2,
            message = 3,
          },
        },
      },
    },
    filetypes = {
      vim = { 'vint' },
      sh = { 'shellcheck' },
      cpp = { 'cpplint' },
      yaml = { 'actionlint' },
    },
    formatters = {},
    formatFiletypes = {},
  },
}))
