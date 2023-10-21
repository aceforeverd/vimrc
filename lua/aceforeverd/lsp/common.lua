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

--- request format from lsp server
--
---@param opts (table|nil)
--               Options passed to vim.lsp.buf.format.
--               For neovim < 0.8.0, this parameter do not take effect
function M.lsp_fmt(opts)
  opts = opts or {}

  if vim.fn.has('nvim-0.8.0') == 1 then
    vim.lsp.buf.format(opts)
  else
    if opts.range ~= nil and opts.range['start'] ~= nil and opts.range['end'] ~= nil then
      vim.lsp.buf.range_formatting({}, opts.range['start'], opts.range['end'])
    else
      vim.lsp.buf.formatting()
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
    vim.notify('ui selector not set for nvim < 0.8.0, fallback to default format')
    if opts.range ~= nil and opts.range['start'] ~= nil and opts.range['end'] ~= nil then
      vim.lsp.buf.range_formatting({}, opts.range['start'], opts.range['end'])
    else
      vim.lsp.buf.formatting()
    end
  end
end

-- command functions for vim commands
--
---@param range number|nil Range value passed from command.
--              Ref :help <range>
-- @param fmt_fn function Function to format the selection or whole buffer
function M.fmt_cmd(range, fmt_fn)
  local opts = {}
  if range == 1 or range == 2 then
    vim.cmd([[exe "normal! \<esc>"]])
    opts = {
      range = {
        ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
        ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
      },
    }
  end

  fmt_fn(opts)
end

local function visual_range_fmt(fmt_fn)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' or mode == 'V' then
    -- execute <esc> first so mark < and > are updated
    vim.cmd([[exe "normal! \<esc>"]])
  end
  fmt_fn({
    range = {
      ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
      ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
    },
  })
end

-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
local function range_format_operator(fmt_fn)
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    fmt_fn({
      range = {
        ['start'] = start,
        ['end'] = finish,
      },
    })
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'

  vim.api.nvim_feedkeys('g@', 'n', false)
end

-- TODO: custom action list with all lsp function
-- one keymap -> [all]

local global_maps = {
  n = {
    ['<c-k>'] = vim.diagnostic.goto_prev,
    ['<c-j>'] = vim.diagnostic.goto_next,

    ['<space>dp'] = vim.diagnostic.open_float,
    -- buffer local diagnostic
    ['<space>q'] = vim.diagnostic.setloclist,
    -- all diagnostic
    ['<space>a'] = vim.diagnostic.setqflist,
  },
}

local lsp_maps = {
  n = {
    ['gd'] = function()
      require('telescope.builtin').lsp_definitions()
    end,
    ['gD'] = vim.lsp.buf.declaration,
    ['gi'] = function()
      require('telescope.builtin').lsp_implementations()
    end,
    ['gr'] = [[<cmd>FzfLua lsp_references<CR>]],
    ['<leader>gd'] = vim.lsp.buf.definition,
    ['<leader>K'] = vim.lsp.buf.hover,
    ['<leader>gK'] = vim.lsp.buf.signature_help,
    ['<leader>gi'] = vim.lsp.buf.implementation,
    ['<leader>gr'] = vim.lsp.buf.references,
    ['<Leader>wa'] = vim.lsp.buf.add_workspace_folder,
    ['<Leader>wr'] = vim.lsp.buf.remove_workspace_folder,
    ['<Leader>wl'] = function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    ['<Leader>D'] = vim.lsp.buf.type_definition,
    ['<Leader>rn'] = vim.lsp.buf.rename,
    ['<Leader>ca'] = vim.lsp.buf.code_action,

    ['<Leader>ci'] = vim.lsp.buf.incoming_calls,
    ['<Leader>co'] = vim.lsp.buf.outgoing_calls,

    -- format whole buffer
    ['<space>F'] = M.lsp_fmt,
    -- LSP format motion
    -- same as `gq`, once setting formatexpr=v:lua.vim.lsp.formatexpr()
    -- I'd keep map `<cr>` to lsp format util find better usage
    [';<cr>'] = function()
      range_format_operator(M.lsp_fmt)
    end,
    [';<cr><cr>'] = function()
      -- format current line
      vim.cmd([[normal! v0o$]])
      visual_range_fmt(M.lsp_fmt)
    end,
    ['g<cr>'] = function()
      range_format_operator(M.selective_fmt)
    end,

    ['<space>s'] = [[<cmd>FzfLua lsp_document_symbols<cr>]],
    ['<space>S'] = function()
      require('telescope.builtin').lsp_workspace_symbols()
    end,
    [';gi'] = 'gi',
  },
  i = {
    ['<c-g>'] = {
      ['<cr>'] = function()
        -- format current line
        vim.cmd([[exe "normal! \<esc>v0o$"]])
        visual_range_fmt(M.lsp_fmt)
        vim.cmd([[normal! gi]])
      end,
    },
  },
  x = {
    ['<cr>'] = function()
      visual_range_fmt(M.lsp_fmt)
    end,
    ['g<cr>'] = function()
      visual_range_fmt(M.selective_fmt)
    end,
    ['<Leader>ca'] = vim.lsp.buf.code_action,
  },
}

function M.keymaps()
  require('aceforeverd.util.map').do_map(global_maps, { silent = true, noremap = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true, noremap = true }
      require('aceforeverd.util.map').do_map(lsp_maps, opts)
    end,
  })
end

function M.on_attach(client, bufnr)
  -- omnifunc, tagfunc, formatexpr is set from neovim runtime by default if LSP supports

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

  -- lsp-status
  local s3, lsp_status = pcall(require, 'lsp-status')
  if s3 then
    lsp_status.on_attach(client)
  end
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities, require('lsp-status').capabilities)
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
  local mes = diagnostic.message

  if diagnostic.code ~= nil then
    mes = mes .. string.format(' [%s]', diagnostic.code)
  end

  -- if diagnostic.user_data then
  --   mes = mes .. string.format(' (%s)', vim.inspect(diagnostic.user_data))
  -- end

  return mes
end
local suffix_fn = function(diagnostic)
  return severity_emoji_map[diagnostic.severity]
end
local pub_diag_config = { virtual_text = true, signs = true, underline = true, update_in_insert = false }
if vim.fn.has('nvim-0.6.0') == 1 then
  pub_diag_config = vim.tbl_deep_extend('force', pub_diag_config, {
    virtual_text = {
      prefix = '🤡', -- Could be '●', '▎', 'x'
      suffix = suffix_fn,
      source = 'always',
      format = fmt_fn,
    },
    severity_sort = true,
    float = {
      suffix = suffix_fn,
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
    signs = vim.tbl_extend('force', signs, { Error = '󰅚 ', Warn = '', Hint = '󰛩 ', Info = '' })
  else
    signs = vim.tbl_extend('force', signs, { Error = '󰅚 ', Warning = '', Hint = '󰛩 ', Information = '' })
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
