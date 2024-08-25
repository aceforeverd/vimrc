-- Copyright (C) 2022  Ace <teapot@aceforeverd.com>
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

function M.select_browse_plugin(plugin_list)
  vim.ui.select(plugin_list, {
    prompt = 'select a plugin',
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice ~= nil then
      vim.api.nvim_call_function('aceforeverd#keymap#browse#open', { choice })
    end
  end)
end

return M
