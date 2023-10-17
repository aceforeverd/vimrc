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

local M = {}

local lsp_basic = require('aceforeverd.lsp.common')

function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  if vim.fn.has('mac') ~= 1 and vim.fn.has('unix') ~= 1 then
    vim.api.nvim_notify('Unsupported system', 3, {})
    return
  end

  -- basic settings
  vim.o.pumblend = 20

  require('aceforeverd.lsp.common').diagnostics_config()
  require('aceforeverd.lsp.common').keymaps()

  vim.cmd([[
    command! -range=% Format  :lua require('aceforeverd.lsp.common').fmt_cmd(<range>, require('aceforeverd.lsp.common').lsp_fmt)
    command! -range=% FormatS :lua require('aceforeverd.lsp.common').fmt_cmd(<range>, require('aceforeverd.lsp.common').selective_fmt)
    ]])

  -- setup lsp installer just before other lsp configurations
  -- so they will inherit lsp-insatller settings, picking up the correct lsp program
  require('aceforeverd.lsp.installer').setup()

  local cfgs = require('aceforeverd.lsp.servers')
  for name, fn in pairs(cfgs) do
    fn(name)
  end
end

function M.go()
  -- :GoInstallBinaries
  require('go').setup({
    lsp_cfg = require('aceforeverd.lsp.common').general_cfg,
    textobjects = false,
    lsp_keymaps = false,
    lsp_inlay_hints = {
      highlight = 'LspInlayHint',
    },
  })
end

function M.rust_analyzer()
  require('rust-tools').setup({
    server = require('aceforeverd.lsp.common').general_cfg,
    tools = {
      inlay_hints = {
        highlight = 'LspInlayHint',
      },
    },
  })
end

function M.hls()
  require('haskell-tools').setup({
    hls = lsp_basic.general_cfg,
  })
end

M.jdtls = require('aceforeverd.lsp.jdtls').setup
M.metals = require('aceforeverd.lsp.metals').setup

return M
