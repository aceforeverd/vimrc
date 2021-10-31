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
if vim.fn.has('nvim-0.6.0') == 0 then
  vim.g.loaded_cmp = true
  return
end

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  print("Unsupported system for windows")
  -- system_name = "Windows"
  return
else
  print("Unsupported system")
  return
end

-- those languages are managed via nvim-lspconfig, while rust, jdtls are managed by specific tool
local managed_ls = {
  'clangd',
  'vimls',
  'bashls',
  'cmake',
  'sumneko_lua',
  'lemminx',
  'yamlls',
  'jsonls'
}

local cmp = require('cmp')
local lspkind = require('lspkind')
-- lsp-status.nvim
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
  diagnostics = true
}
lsp_status.register_progress()

local default_map_opts = { noremap = true, silent = true }

cmp.setup({
  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'look', keyword_length = 2, default_map_opts = { convert_case = true, loud = true } },
    { name = 'emoji' },
    { name = 'treesitter' },
    { name = 'tmux' },
    { name = 'spell' },
    { name = 'cmdline' }
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      menu = {
        nvim_lsp = "[LSP]",
        vsnip = "[Vsnip]",
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lua = "[Lua]",
        look = "[Look]",
        emoji = "[Emoji]",
        treesitter = "[TreeSitter]",
        tmux = "[Tmux]",
        luasnip = "[LuaSnip]",
        latex_symbols = "[Latex]",
        spell = '[Spell]',
        cmdline = '[Cmdline]',
        nvim_lsp_document_symbol = '[DocumentSymbol]'
      }
    })
  }
})

cmp.setup.cmdline('/', {
  sources = cmp.config.sources({ { name = 'nvim_lsp_document_symbol' } }, { { name = 'buffer' } })
})
cmp.setup.cmdline('?', {
  sources = cmp.config.sources({ { name = 'nvim_lsp_document_symbol' } }, { { name = 'buffer' } })
})

-- vsnip
vim.api.nvim_set_keymap('i', '<c-j>',
                        "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'",
                        { expr = true })
vim.api.nvim_set_keymap('s', '<c-j>',
                        "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'",
                        { expr = true })

vim.api.nvim_set_keymap('n', 's', '<Plug>(vsnip-select-text)', default_map_opts)
vim.api.nvim_set_keymap('x', 's', '<Plug>(vsnip-select-text)', default_map_opts)
vim.api.nvim_set_keymap('n', 'S', '<Plug>(vsnip-cut-text)', default_map_opts)
vim.api.nvim_set_keymap('x', 'S', '<Plug>(vsnip-cut-text)', default_map_opts)

local lspconfig = require('lspconfig')
local lsp_basic = require('aceforeverd.config.lsp-basic')
local on_attach = lsp_basic.on_attach
local capabilities = lsp_basic.capabilities

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>af', '<cmd>ClangdSwitchSourceHeader<cr>',
                                { noremap = true, silent = true })
  end,
  capabilities = capabilities,
  handlers = lsp_status.extensions.clangd.setup(),
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

-- pre-installed lsp server managed by nvim-lsp-installer, installed in stdpath('data')
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  -- local opts = {}
  if server.name == 'sumneko_lua' then
    local sumneko_root_path = server.root_dir .. '/extension/server'
    local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' }
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false }
        }
      }
    }
  elseif server.name == 'rust_analyzer' then
    require('rust-tools').setup {
      server = {
        cmd = { server.root_dir .. '/rust-analyzer' },
        on_attach = on_attach,
        capabilities = capabilities
      }
    }
  elseif server.name == 'cmake' then
    lspconfig.cmake.setup {
      cmd = { server.root_dir .. '/venv/bin/cmake-language-server' },
      on_attach = on_attach,
      capabilities = capabilities
    }
  elseif server.name == 'lemminx' then
    lspconfig.lemminx.setup {
      cmd = { server.root_dir .. '/lemminx' },
      on_attach = on_attach,
      capabilities = capabilities
    }
  elseif server.name == 'yamlls' then
    lspconfig.yamlls.setup {
      cmd = {
        server.root_dir .. '/node_modules/yaml-language-server/bin/yaml-language-server',
        '--stdio'
      },
      on_attach = on_attach,
      capabilities = capabilities
    }
  -- elseif server.name == 'diagnosticls' then
  --   lspconfig.diagnosticls.setup {
  --     cmd = { server.root_dir .. '/node_modules/diagnostic-languageserver/bin/index.js', '--stdio' },
  --     filetypes = { 'cpp', 'sh', 'vim' },
  --     init_options = {
  --       languageserver = { }
  --     }
  --   }
  elseif server.name == 'bashls' then
    lspconfig.bashls.setup {
      cmd = { server.root_dir .. '/node_modules/bash-language-server/bin/main.js', 'start' },
      on_attach = on_attach,
      capabilities = capabilities
    }
  end
end)

lspconfig.vimls.setup { on_attach = on_attach, capabilities = capabilities }

