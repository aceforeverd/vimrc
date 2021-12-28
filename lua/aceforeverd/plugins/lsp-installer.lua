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

----------------------------------------------------------------------
--        use lsp-installer only to handle lsps that is not         --
--                easy to setup from system package                 --
----------------------------------------------------------------------
if vim.g.my_cmp_source ~= 'nvim_lsp' then
  return
end

if vim.fn.has("mac") ~= 1 and vim.fn.has('unix') ~= 1 then
  print("Unsupported system")
  return
end

-- TODO: if a lsp server is not available (command not found), install and setup via lsp-installer

local on_attach = require('aceforeverd.config.lsp-basic').on_attach
local capabilities = require('aceforeverd.config.lsp-basic').capabilities

local general_lsp_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

local setup_sumeko_lua = function(server)
  local luadev = require("lua-dev").setup({
    runtime_path = true, -- it will be slow
    -- add any options here, or leave empty to use the default settings
    lspconfig = {
      on_attach = on_attach,
      capabilities = capabilities,
    },
  })

  -- vim.api.nvim_notify(require('luaunit').prettystr(luadev), 2, {})

  server:setup(luadev)
end

local setup_cmake = function(server)
    server:setup (general_lsp_config)
end

local setup_lemminux = function(server)
    server:setup(general_lsp_config)
end

local setup_bashls = function(server)
  server:setup(vim.tbl_deep_extend('force', general_lsp_config, {}))
end

local setup_diagnosticls = function(server)
  server:setup(
    vim.tbl_deep_extend('keep', general_lsp_config, require('aceforeverd.plugins.lsp.diagnosticls').get_config())
  )
end

local setup_lsp_configs = {
  sumneko_lua = setup_sumeko_lua,
  cmake = setup_cmake,
  lemminx = setup_lemminux,
  bashls = setup_bashls,
  diagnosticls = setup_diagnosticls,
}

-- pre-installed lsp server managed by nvim-lsp-installer, installed in stdpath('data')
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local setup_func = setup_lsp_configs[server.name]
  if setup_func ~= nil then
    setup_func(server)
  end
end)
