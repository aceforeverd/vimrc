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
-- those languages are managed via nvim-installer through nvim-lsp-installer
local managed_ls = {
  'bashls',
  'cmake',
  'sumneko_lua',
  'lemminx',
  'yamlls',
  'jsonls'
}
-- pre-installed lsp server managed by nvim-lsp-installer, installed in stdpath('data')
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  -- local opts = {}
  local atch = require('aceforeverd.config.lsp-basic').on_attach
  local caps = require('aceforeverd.config.lsp-basic').capabilities
  if server.name == 'sumneko_lua' then
    local sumneko_root_path = server.root_dir .. '/extension/server'
    local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    server:setup {
      on_attach = atch,
      capabilities = caps,
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
        on_attach = atch,
        capabilities = caps
      }
    }
  elseif server.name == 'cmake' then
    server:setup {
      cmd = { server.root_dir .. '/venv/bin/cmake-language-server' },
      on_attach = atch,
      capabilities = caps
    }
  elseif server.name == 'lemminx' then
    server:setup {
      cmd = { server.root_dir .. '/lemminx' },
      on_attach = atch,
      capabilities = caps
    }
  elseif server.name == 'yamlls' then
    server:setup {
      cmd = {
        server.root_dir .. '/node_modules/yaml-language-server/bin/yaml-language-server',
        '--stdio'
      },
      on_attach = atch,
      capabilities = caps
    }
  elseif server.name == 'bashls' then
    server:setup {
      cmd = { server.root_dir .. '/node_modules/bash-language-server/bin/main.js', 'start' },
      on_attach = atch,
      capabilities = caps
    }
  end
end)
