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

-- some mapping may not work for nvim < 0.7.0 due to can't map function-rhs
local map_fn = vim.fn.has('nvim-0.7.0') == 1 and vim.keymap.set or vim.api.nvim_set_keymap

--- create map based on a table
---@param map_list dict first level key should be vim mode name, e.g 'n', 'v'
--                      TODO: for nvim >= 0.7, first level key can be a list e.g { 'n', 'x' }
---@param map_opts dict
function M.do_map(map_list, map_opts)
  if type(map_list) ~= "table" then
    vim.api.nvim_notify('[skip]: map_list not a table: ' .. vim.inspect(map_list), vim.log.levels.WARN, {})
  end

  for k, v in pairs(map_list) do
    -- though it do not check if first level key is a vim mode string
    M.do_mode_map(k, '', v, map_opts)
  end
end

function M.do_mode_map(mode, prefix, map_list, map_opts)
  if type(prefix) ~= 'string' then
    vim.api.nvim_notify('[skip]: prefix is not string', vim.log.levels.WARN, {})
  end

  if type(map_list) == 'table' then
    for key, value in pairs(map_list) do
      M.do_mode_map(mode, prefix .. key, value)
    end
  else
    M.set_map(mode, prefix, map_list, map_opts or {})
  end
end

function M.set_map(mode, lhs, rhs, opts)
  if type(rhs) == 'string' then
    map_fn(mode, lhs, rhs, opts or {})
  elseif type(rhs) == 'function' then
    if vim.fn.has('nvim-0.7.0') == 1 then
      map_fn(mode, lhs, rhs, opts or {})
    else
      vim.api.nvim_notify('[skip]: map function-rhs for neovim < 0.7.0: ' .. vim.inspect(rhs), vim.log.levels.WARN, {})
    end
  else

    vim.api.nvim_notify('[skip]: map rhs is not string/function: ' ..
      vim.inspect(rhs), vim.log.levels.WARN, {})
  end
end

return M
