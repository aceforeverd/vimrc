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

local M = {}

local default_map_opts = { noremap = true, silent = true }
local lsp_status = require('lsp-status')

function M.on_attach(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', default_map_opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', default_map_opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', default_map_opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', default_map_opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', default_map_opts)
  buf_set_keymap('n', 'gK', '<cmd>lua vim.lsp.buf.signature_help()<CR>', default_map_opts)
  buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', default_map_opts)
  buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', default_map_opts)
  buf_set_keymap(
    'n',
    '<Leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    default_map_opts
  )
  buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', default_map_opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', default_map_opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', default_map_opts)

  buf_set_keymap('n', '<Leader>ci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', default_map_opts)
  buf_set_keymap('n', '<Leader>co', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', default_map_opts)

  buf_set_keymap('n', '<c-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', default_map_opts)
  buf_set_keymap('n', '<c-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>', default_map_opts)

  buf_set_keymap('n', '<space>dp', '<cmd>lua vim.diagnostic.open_float()<CR>', default_map_opts)
  -- buffer local diagnostic
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', default_map_opts)
  -- all diagnostic
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.diagnostic.setqflist()<CR>', default_map_opts)

  buf_set_keymap('n', '<space>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', default_map_opts)
  buf_set_keymap('v', '<cr>', ':lua vim.lsp.buf.range_formatting()<cr>', { noremap = true })

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

  require('illuminate').on_attach(client)

  -- lsp_signature.nvim
  require('lsp_signature').on_attach({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
    transparency = 25,
    toggle_key = '<A-x>',
  }, bufnr)

  require('lsp-status').on_attach(client)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
M.capabilities = capabilities

-- basic border, check :help nvim_open_win()
local border = {
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

local severity_emoji_map = {
  [vim.diagnostic.severity.ERROR] = '😡',
  [vim.diagnostic.severity.WARN] = '😨',
  [vim.diagnostic.severity.INFO] = '😟',
  [vim.diagnostic.severity.HINT] = '🤔',
}

local pub_diag_config = { virtual_text = true, signs = true, underline = true, update_in_insert = false }
if vim.fn.has('nvim-0.6.0') == 1 then
  pub_diag_config['virtual_text'] = {
    prefix = '🤡', -- Could be '●', '▎', 'x'
    source = 'always',
    format = function(diagnostic)
      return string.format('%s %s', diagnostic.message, severity_emoji_map[diagnostic.severity])
    end,
  }
  pub_diag_config['float'] = { source = 'always' }
end

M.handlers = {
  ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, pub_diag_config),
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  ['textDocument/definition'] = require('fzf_lsp').definition_handler,
  ['textDocument/implementation'] = require('fzf_lsp').implementation_handler,
  ['textDocument/references'] = require('fzf_lsp').references_handler,
}

M.general_cfg = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  handlers = M.handlers,
}

return M
