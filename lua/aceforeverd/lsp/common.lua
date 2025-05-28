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

-- basic border, check :help nvim_open_win()
local border = {
  -- NOTE: ref 'winborder' option
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

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
    end, vim.lsp.get_clients({ bufnr = 0 }))

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

local lsp_global_maps = {
  n = {
    ['<c-k>'] = {function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, {desc = 'previous diagnostic'} },
    ['<c-j>'] = {function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, {desc = 'next diagnostic'} },

    ['<space>dp'] = {vim.diagnostic.open_float, {desc = 'show diagnostic in float window'} },
    -- buffer local diagnostic
    ['<space>q'] = { vim.diagnostic.setloclist, {desc = 'buf-local diagnostics to the location list'}},
    -- all diagnostic
    ['<space>a'] = {vim.diagnostic.setqflist, {desc = 'all diagnostics to the quickfix list'}},
    ['<space>I'] = {function()
      local enabled = vim.lsp.inlay_hint.is_enabled()
      vim.lsp.inlay_hint.enable(not enabled)
      if enabled then
        vim.notify('inlay hint DISABLED!', vim.log.levels.INFO)
      else
        vim.notify('inlay hint ENABLED', vim.log.levels.INFO)
      end
    end, {desc = 'GLOBAL toggle inlay hint'}},
  },
}

local lsp_buf_maps = {
  n = {
    ['gd'] = { vim.lsp.buf.definition, { desc = 'go to definition' } },
    ['gD'] = { vim.lsp.buf.declaration, opts = { desc = 'go to declaration' } },
    ['gi'] = {
      function()
        require('telescope.builtin').lsp_implementations()
      end,
      { desc = '[telescope] implementations' },
    },
    ['gr'] = { [[<cmd>FzfLua lsp_references<CR>]], { desc = 'lsp references' } },
    -- NOTE: hit 'K' again to jump to the float window
    ['K'] = {
      function()
        vim.lsp.buf.hover({ border = border, title = 'LSP Hover' })
      end,
      { desc = 'hover' },
    },
    ['gK'] = {
      function()
        vim.lsp.buf.signature_help({ border = border, title = 'LSP Signature Help' })
      end,
      { desc = 'signature help' },
    },
    ['<leader>gd'] = {
      function()
        require('telescope.builtin').lsp_definitions()
      end,
      { desc = 'telescope lsp definitions' },
    },
    ['<leader>gi'] = { vim.lsp.buf.implementation, { desc = 'implementations' } },
    ['<leader>gr'] = { vim.lsp.buf.references, { desc = 'references' } },
    ['<Leader>wa'] = { vim.lsp.buf.add_workspace_folder, { desc = 'add workspace folder' } },
    ['<Leader>wr'] = { vim.lsp.buf.remove_workspace_folder, { desc = 'rm workspace folder' } },

    ['<Leader>wl'] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      { desc = 'list workspace folders' },
    },
    ['<Leader>D'] = { vim.lsp.buf.type_definition, { desc = 'type definition' } },
    ['<Leader>rn'] = { vim.lsp.buf.rename, { desc = 'rename' } },
    ['<Leader>ca'] = { vim.lsp.buf.code_action, { desc = 'codeaction' } },

    ['<Leader>ci'] = { vim.lsp.buf.incoming_calls, { desc = 'incoming calls' } },
    ['<Leader>co'] = { vim.lsp.buf.outgoing_calls, { desc = 'outgoing calls' } },
    ['<Leader>a'] = {
      -- toggle lsp inlay hint on current buffer
      ['i'] = {
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
            bufnr = 0,
          }), { bufnr = 0 })
        end,
        { desc = 'BUF-LOCAL toggle inlay hint' },
      },
    },

    -- format whole buffer
    ['<space>F'] = { M.lsp_fmt, { desc = 'format' } },
    -- LSP format motion
    -- same as `gq`, once setting formatexpr=v:lua.vim.lsp.formatexpr()
    -- I'd keep map `<cr>` to lsp format util find better usage
    [';<cr>'] = {
      function()
        range_format_operator(M.lsp_fmt)
      end,
      { desc = 'format motion' },
    },
    [';<cr><cr>'] = {
      function()
        -- format current line
        vim.cmd([[normal! v0o$]])
        visual_range_fmt(M.lsp_fmt)
      end,
      { desc = 'format current line' },
    },
    ['g<cr>'] = {
      function()
        range_format_operator(M.selective_fmt)
      end,
      { desc = 'format motion selective' },
    },

    ['<space>s'] = { [[<cmd>FzfLua lsp_document_symbols<cr>]], { desc = 'document symbols' } },
    ['<space>S'] = {
      function()
        require('telescope.builtin').lsp_workspace_symbols()
      end,
      { desc = 'workspace symbols' },
    },

    -- vim defaults
    ['<space>gi'] = { 'gi', { desc = 'Insert text in the same position as where Insert mode was stopped' } },
    ['<space>gr'] = { 'gr', { desc = 'Replace the virtual characters under the cursor with {char}' } },
  },
  i = {
    ['<c-g>'] = {
      ['<cr>'] = {
        function()
          -- format current line
          vim.cmd([[exe "normal! \<esc>v0o$"]])
          visual_range_fmt(M.lsp_fmt)
          vim.cmd([[normal! gi]])
        end,
        { desc = 'format current line' },
      },
    },
  },
  x = {
    ['<cr>'] = {
      function()
        visual_range_fmt(M.lsp_fmt)
      end,
      { desc = 'range format' },
    },
    ['g<cr>'] = {
      function()
        visual_range_fmt(M.selective_fmt)
      end,
      { desc = 'selective range format' },
    },
    ['<Leader>ca'] = { vim.lsp.buf.code_action, { desc = 'code actions' } },
  },
}

function M.keymaps()
  require('aceforeverd.util.map').do_map(lsp_global_maps, { silent = true, noremap = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true, noremap = true }
      require('aceforeverd.util.map').do_map(lsp_buf_maps, opts)

      -- enable inlay hint
      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
    end,
  })
end

function M.on_attach(client, bufnr)
  -- omnifunc, tagfunc, formatexpr is set from neovim runtime by default if LSP supports
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
M.capabilities = capabilities

M.handlers = {
  -- 'textDocument/publishDiagnostics' handles only server-to-client, replaced by vim.diagnostic.config()
  -- ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, require('aceforeverd.lsp.diagnostic').diag_config),
}

M.general_cfg = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  handlers = M.handlers,
}

return M
