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

function M.setup()
  local lsp_installer = require('nvim-lsp-installer')
  local available, server = lsp_installer.get_server('rust_analyzer')

  if not available then
    vim.api.nvim_notify('rust analyzer not available from lsp-installer, install manually', 3, {})
    return
  end

  if not server:is_installed() then
    vim.api.nvim_notify('installing rust analyzer via lsp-installer', 2, {})
    server:install()
  end

  require('rust-tools').setup({
    server = {
      cmd = { server.root_dir .. '/rust-analyzer' },
      on_attach = require('aceforeverd.lsp.common').on_attach,
      capabilities = require('aceforeverd.lsp.common').capabilities,
    }
  })
end

return M
