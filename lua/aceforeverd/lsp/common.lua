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

--- request lsp range format
---@param start table
---@param finish table
---@param opts table|nil same table pass to `vim.lsp.buf.format`
local function range_fmt(start, finish, opts)
  if vim.fn.has('nvim-0.8.0') == 1 then
    opts = opts or {}
    vim.lsp.buf.format(vim.tbl_deep_extend(
      'force',
      -- opts may contains range info, but the `start`, `finish` parameters are preferred
      opts,
      { range = {
        ['start'] = start,
        ['end'] = finish,
      } }
    ))
  else
    vim.lsp.buf.range_formatting({}, start, finish)
  end
end

--- request format from lsp server
--
---@param range number|nil Range value passed from command.
--              Ref :help <range>
---@param opts (table|nil)
--               Options passed to vim.lsp.buf.format.
--               For neovim < 0.8.0, this parameter do not take effect
function M.lsp_fmt(range, opts)
  opts = opts or {}

  if range == 1 or range == 2 then
    -- assume visual mode, get previous visual selection
    -- used by 'Format' command
    local start = vim.api.nvim_buf_get_mark(0, '<')
    local finish = vim.api.nvim_buf_get_mark(0, '>')
    range_fmt(start, finish, opts)
  else
    -- auto format based on mode and visual selection
    local mode = vim.api.nvim_get_mode()
    if mode.mode == 'n' then
      if vim.fn.has('nvim-0.8.0') == 1 then
        vim.lsp.buf.format(opts)
      else
        vim.lsp.buf.formatting()
      end
    elseif mode.mode == 'v' or mode.mode == 'V' then
      vim.cmd([[exe "normal! \<esc>"]])
      local start = vim.api.nvim_buf_get_mark(0, '<')
      local finish = vim.api.nvim_buf_get_mark(0, '>')
      range_fmt(start, finish, opts)
    else
      vim.api.nvim_notify('unhandled mode: ' .. vim.inspect(mode), vim.log.levels.WARN, {})
    end
  end
end

-- selective lsp format, same behavior to `vim.lsp.buf.formatting`
-- for neovim >= 0.8.0 only
function M.selective_fmt(opts)
  if vim.fn.has('nvim-0.8.0') == 1 then
    local available_clients = vim.tbl_filter(function(elem)
      return elem.server_capabilities.documentFormattingProvider == true
    end, vim.lsp.get_active_clients({ bufnr = 0 }))

    vim.ui.select(available_clients, {
      prompt = 'select a server:',
      format_item = function(client)
        return string.format('(%d) %s', client.id, client.name)
      end,
    }, function(choice, _)
      if choice ~= nil then
        vim.lsp.buf.format(vim.tbl_deep_extend('force', opts or {}, {
          filter = function(client)
            return client.id == choice.id
          end,
        }))
      end
    end)
  else
    vim.notify("no effect", vim.log.levels.WARN, {})
  end
end

-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
M.range_format_operator = function()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    if vim.fn.has('nvim-0.8.0') == 1 then
      vim.lsp.buf.format({
        bufnr = 0,
        range = {
          ['start'] = start,
          ['end'] = finish,
        },
      })
    else
      vim.lsp.buf.range_formatting({}, start, finish)
    end
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'

  vim.api.nvim_feedkeys('g@', 'n', false)
end

local lsp_default_maps = {
  n = {
    ['gd'] = [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]],
    ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<CR>',
    ['K'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['gi'] = [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]],
    ['gr'] = [[<cmd>FzfLua lsp_references<CR>]],
    ['gK'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    ['<Leader>wa'] = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
    ['<Leader>wr'] = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
    ['<Leader>wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    ['<Leader>D'] = '<cmd>lua vim.lsp.buf.type_definition()<CR>',
    ['<Leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    ['<Leader>ca'] = '<cmd>lua vim.lsp.buf.code_action()<CR>',

    ['<Leader>ci'] = '<cmd>lua vim.lsp.buf.incoming_calls()<CR>',
    ['<Leader>co'] = '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>',

    ['<c-k>'] = '<cmd>lua vim.diagnostic.goto_prev()<CR>',
    ['<c-j>'] = '<cmd>lua vim.diagnostic.goto_next()<CR>',

    ['<space>dp'] = '<cmd>lua vim.diagnostic.open_float()<CR>',
    -- buffer local diagnostic
    ['<space>q'] = '<cmd>lua vim.diagnostic.setloclist()<CR>',
    -- all diagnostic
    ['<space>a'] = '<cmd>lua vim.diagnostic.setqflist()<CR>',

    ['<space>F'] = M.lsp_fmt,
    ['g<cr>'] = [[<cmd>lua require('aceforeverd.lsp.common').range_format_operator()<cr>]],
    ['<space>s'] = [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]],
    ['<space>S'] = [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]],

    ['<leader>gi'] = 'gi',
  },
  x = {
    ['<cr>'] = M.lsp_fmt,
    ['g<cr>'] = function()
      -- execute <esc> first so mark < and > are updated
      vim.cmd([[exe "normal! \<esc>"]])
      M.selective_fmt({
        range = {
          ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
          ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
        },
      })
    end,
  },
}

function M.on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require('aceforeverd.utility.map').do_map(lsp_default_maps, default_map_opts)

  vim.cmd([[command! -range=% Format :lua require('aceforeverd.lsp.common').lsp_fmt(<range>)]])

  require('illuminate').on_attach(client)

  local s1, aerial = pcall(require, 'aerial')
  if s1 then
    aerial.on_attach(client, bufnr)
    require('aceforeverd.utility.map').set_map('n', '<space>t', [[<cmd>AerialToggle!<cr>]], default_map_opts)
  end

  -- lsp_signature.nvim
  local s2, lsp_signature = pcall(require, 'lsp_signature')
  if s2 then
    lsp_signature.on_attach({
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
      transparency = 25,
      toggle_key = '<A-x>',
    }, bufnr)
  end

  if client.server_capabilities.documentSymbolProvider then
    local s3, navic = pcall(require, 'nvim-navic')
    if s3 then
      navic.attach(client, bufnr)
    end
  end

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

local fmt_fn = function(diagnostic)
  return string.format('%s %s', diagnostic.message, severity_emoji_map[diagnostic.severity])
end
local pub_diag_config = { virtual_text = true, signs = true, underline = true, update_in_insert = false }
if vim.fn.has('nvim-0.6.0') == 1 then
  pub_diag_config = vim.tbl_deep_extend('force', pub_diag_config, {
    virtual_text = {
      prefix = '🤡', -- Could be '●', '▎', 'x'
      source = 'always',
      format = fmt_fn,
    },
    severity_sort = true,
    float = {
      source = 'always',
      severity_sort = true,
      format = fmt_fn,
    },
  })
end

M.diagnostics_config = function()
  vim.diagnostic.config(pub_diag_config)

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
end

M.handlers = {
  ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, pub_diag_config),
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

M.general_cfg = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  handlers = M.handlers,
}

return M
