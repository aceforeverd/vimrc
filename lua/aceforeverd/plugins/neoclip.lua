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
  require('neoclip').setup {
    enable_persistant_history = true,
    db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
    keys = {
      i = { select = '<c-y>', paste = '<cr>', paste_behind = '<c-l>', custom = {} },
      n = { select = '<c-y>', paste = 'p', paste_behind = 'P', custom = {} },
    },
  }

  vim.api.nvim_set_keymap('n', '<space>l', ':lua require("telescope").extensions.neoclip.default()<cr>',
                          { silent = true, noremap = true })
end

return M
