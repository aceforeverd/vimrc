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

function M.luasnip_setup()
  local luasnip = require('luasnip')
  -- local types = require('luasnip.util.types')
  luasnip.config.setup({
    ext_opts = {
      history = true,
      -- [types.choiceNode] = {
      --     active = {
      --         virt_text = { { '●', 'DiffAdd' } },
      --     },
      -- },
      -- [types.insertNode] = {
      --     active = {
      --         virt_text = { { '●', 'DiffDelete' } },
      --     },
      -- },
    },
  })

  require('luasnip.loaders.from_vscode').lazy_load()

  -- keymaps defined in nvim-cmp.lua
end

function M.ultisnip_setup_pre()
  -- ultisnips is in starter plugin list in order to avoid multiple source created in nvim-cmp
  -- if g:with_ultisnips is on, prevent load ultisnips
  -- be aware a source 'ultisnips' will still show up in :CmpStatus, but unavailable
  if vim.g.with_ultisnips == 0 then
    vim.g.did_plugin_ultisnips = 1
    return
  end

  vim.g.UltiSnipsRemoveSelectModeMappings = 0

  require("cmp_nvim_ultisnips").setup{}

  -- TODO:: condional map
  vim.g.UltiSnipsExpandTrigger = '<M-l>'
  vim.g.UltiSnipsListSnippets = '<c-tab>'
  vim.g.UltiSnipsJumpForwardTrigger = '<c-j>'
  vim.g.UltiSnipsJumpBackwardTrigger = '<c-k>'
end

return M
