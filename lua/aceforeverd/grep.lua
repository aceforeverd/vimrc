--[[--
Copyright (c) 2024 Ace <teapot@aceforeverd.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]--

---@param opts table ast grep search pattern
local function ast_grep_search(opts)
  local args = opts.fargs
  local pattern = args[1]

  local cmds = { 'ast-grep', 'run', '--heading', 'never', '--pattern', pattern }
  for i = 2, #args, 1 do
    table.insert(cmds, args[i])
  end

  local expr = string.format(
    'system([%s])',
    vim.iter(cmds):map(function(v)
      return vim.fn.shellescape(v)
    end):join(", ")
  )
  vim.cmd('lgetexpr ' .. expr)
  vim.cmd('lopen')
end

return {
  ast_grep = ast_grep_search
}
