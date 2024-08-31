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
  local go_cfg = require('aceforeverd.lsp.common').general_cfg
  -- https://github.com/ray-x/go.nvim?tab=readme-ov-file#nvim-lsp-setup
  go_cfg.settings = {
    gopls = {
      -- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
      analyses = {
        unreachable = true,
        nilness = true,
        unusedparams = true,
        useany = true,
        unusedwrite = true,
        ST1003 = true,
        undeclaredname = true,
        fillreturns = true,
        nonewvars = true,
        fieldalignment = true,
        shadow = true,
      },
    },
  }
  go_cfg.capabilities.textDocument.completion.dynamicRegistration = true

  -- :GoInstallBinaries
  require('go').setup({
    lsp_cfg = go_cfg,
    textobjects = false,
    lsp_keymaps = false,
    lsp_inlay_hints = {
      highlight = 'LspInlayHint',
    },
  })
end

M.jdtls = require('aceforeverd.lsp.jdtls').setup
M.metals = require('aceforeverd.lsp.metals').setup

--- Set directory for curent buffer. By LSPs firstly, if non available, use fallback function
--- @param fallback function Fallback function returns root directory as string
function M.find_root(fallback)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then
    return nil
  end

  local dirs = vim
    .iter(clients)
    :filter(function(client)
      local filetypes = client.config.filetypes
      if filetypes and vim.tbl_contains(filetypes, ft) then
        return true
      end

      return false
    end)
    :map(function(client)
      return { root = client.config.root_dir, client = client.name }
    end)

  if fallback ~= nil then
    table.insert(dirs, { root = fallback(), client = 'fallback' })
  end

  vim.ui.select(dirs, {
    prompt = 'select root directory',
    format_item = function(info)
      return info.name .. ': ' .. info.root
    end,
  }, function(choice)
    if choice ~= nil then
      M.set_pwd(choice.root, 'win')
    end
  end)
end

function M.set_pwd(dir, method)
  if dir ~= nil then
    if vim.fn.getcwd() ~= dir then
      local scope_chdir = method or 'win'
      if scope_chdir == 'global' then
        vim.api.nvim_set_current_dir(dir)
      elseif scope_chdir == 'tab' then
        vim.cmd('tcd ' .. dir)
      elseif scope_chdir == 'win' then
        vim.cmd('lcd ' .. dir)
      else
        return
      end

      vim.notify('Set CWD to ' .. dir .. ' using ' .. method)
    end
  end
end

return M
