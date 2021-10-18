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
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
  return
end

local managed_ls = { 'clangd', 'vimls', 'rust_analyzer', 'bashls', 'cmake', 'sumneko_lua' }

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
  diagnostics = true,
}

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
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
    { name = 'look', keyword_length = 2, opts = { convert_case = true, loud = true } },
    { name = 'emoji' },
  },
  formatting = { format = lspkind.cmp_format({ with_text = true, maxwidth = 50, menu = {
    nvim_lsp = "[LSP]",
    vsnip = "[Vsnip]",
    buffer = "[Buffer]",
    path = "[Path]",
    nvim_lua = "[Lua]",
    look = "[Look]",
    emoji = "[Emoji]",
    luasnip = "[LuaSnip]",
    latex_symbols = "[Latex]",
  } }) }
})

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl',
                 '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- lsp_signature.nvim
  require('lsp_signature').on_attach()
  -- vim-illuminate
  require('illuminate').on_attach(client)

  lsp_status.on_attach(client)
end

local lspconfig = require('lspconfig')
lsp_status.register_progress()
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

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
  end
end)

lspconfig.vimls.setup { on_attach = on_attach, capabilities = capabilities }

lspconfig.bashls.setup { on_attach = on_attach, capabilities = capabilities }

if vim.o.filetype == 'java' then
  require('jdtls').start_or_attach {
    -- The command that starts the language server
    cmd = {
      'java',
      '-Dosgi.bundles.defaultStartLevel=4',
    },
    -- TODO: add more mappings from nvim-jdtls
    on_attach = on_attach,
    capabilities = capabilities,

    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
  }
end
