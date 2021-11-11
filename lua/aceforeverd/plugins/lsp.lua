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

local lspconfig = require('lspconfig')
local lsp_basic = require('aceforeverd.config.lsp-basic')
local on_attach = lsp_basic.on_attach
local capabilities = lsp_basic.capabilities

local lsp_status = require('lsp-status')
lsp_status.config {
  select_symbol = function(cursor_pos, symbol)
    if symbol.valueRange then
      local value_range = {
        ["start"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
        ["end"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) }
      }

      return require("lsp-status.util").in_range(cursor_pos, value_range)
    end
  end,
  current_function = false,
  show_filename = false,
  status_symbol = '',
  diagnostics = false
}
lsp_status.register_progress()

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>af', '<cmd>ClangdSwitchSourceHeader<cr>',
                                { noremap = true, silent = true })
  end,
  capabilities = capabilities,
  handlers = require('lsp-status').extensions.clangd.setup(),
  init_options = { clangdFileStatus = true },
  cmd = {
    'clangd',
    '--background-index',
    "--clang-tidy",
    "--cross-file-rename",
    "--all-scopes-completion",
    "--suggest-missing-includes"
  }
}

lspconfig.vimls.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.pyright.setup { on_attach = on_attach, capabilities = capabilities }

