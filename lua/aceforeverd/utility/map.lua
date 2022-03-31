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

-- reclusively create normal map from a map list
function M.do_nmap(prefix, map_list, map_opts)
  if type(prefix) ~= 'string' then
    vim.api.nvim_notify('[skip]: prefix is not string', vim.log.levels.WARN, {})
  end

  if type(map_list) == 'table' then
    for key, value in pairs(map_list) do
      M.do_nmap(prefix .. key, value)
    end
  elseif type(map_list) == 'string' then
    vim.api.nvim_set_keymap('n', prefix, map_list, map_opts or {})
  else
    vim.api.nvim_notify('[skip]: map_list is not table', vim.log.levels.WARN, {})
  end
end

function M.set_map(mode, lhs, rhs, opts)
  if vim.fn.has('nvim-0.7.0') == 1 then
    vim.keymap.set(mode, lhs, rhs, opts or {})
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {})
  end

end

return M
