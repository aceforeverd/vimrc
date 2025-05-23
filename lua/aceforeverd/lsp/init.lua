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

function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  if vim.fn.has('mac') ~= 1 and vim.fn.has('unix') ~= 1 then
    vim.notify('Unsupported system', 3, {})
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

  -- general lsp setup for all
  vim.lsp.config('*', require('aceforeverd.lsp.common').general_cfg)

  -- extra lsp cfg for each lsp server
  local cfgs = require('aceforeverd.lsp.servers')
  for name, cfg_override in pairs(cfgs) do
    if type(cfg_override) == 'table' then
      vim.lsp.config(name, cfg_override)
    elseif type(cfg_override) == 'function' then
      vim.lsp.config(name, cfg_override())
    else -- just assume no extra config apply
    end
    vim.lsp.enable(name)
  end
end

function M.go()
  -- :GoInstallBinaries
  require('go').setup({
    lsp_cfg = false,
    textobjects = false,
    lsp_keymaps = false,
    diagnostic = false, -- not conflict with global diagnostic
    lsp_inlay_hints = {
      highlight = 'LspInlayHint',
    },
  })

  local go_cfg = require('go.lsp').config()
  -- https://github.com/ray-x/go.nvim?tab=readme-ov-file#nvim-lsp-setup
  go_cfg.settings.gopls.analyses.fieldalignment = false
  vim.lsp.config('gopls', go_cfg)
  vim.lsp.enable('gopls')
end

M.jdtls = require('aceforeverd.lsp.jdtls').setup
M.metals = require('aceforeverd.lsp.metals').setup

return M
