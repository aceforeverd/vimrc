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
  require('luasnip.loaders.from_snipmate').lazy_load()

  -- keymaps defined in nvim-cmp.lua
end

return M
