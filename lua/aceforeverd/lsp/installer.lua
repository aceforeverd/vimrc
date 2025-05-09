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

-- TODO: if a lsp server is not available (command not found), prompt install and setup via lsp-installer
-- like this:
--[[
  local lsp_installer_servers = require('nvim-lsp-installer.servers')
  local available, server = lsp_installer_servers.get_server('jdtls')

  if not available then
    vim.api.nvim_notify('jdtls not available from lsp-installer, install manually', 3, {})
    return ''
  end

  if not server:is_installed() then
    vim.api.nvim_notify('installing jdtls via lsp-installer', 2, {})
    server:install()
  end
]]

function M.setup()
  -- Mason.nvim
  -- Easily install lsp servers, dap servers, linters and formaters
  require('mason').setup()
  require('mason-lspconfig').setup(
    { automatic_enable = false }
  )
end

return M
