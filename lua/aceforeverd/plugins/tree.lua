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

function M.neo_tree()
  require('neo-tree').setup({
    filesystem = {
      hijack_netrw_behavior = 'disabled',
      window = {
        mappings = {
          ['o'] = 'open',
          ['g/'] = 'filter_as_you_type',
          ['gf'] = 'filter_on_submit',
          ['g?'] = 'show_help',
          ['/'] = 'none',
          ['?'] = 'none',
          ['f'] = 'none',
        },
      },
    },
  })

  require('aceforeverd.utility.map').set_map('n', '<space>e', '<cmd>Neotree toggle reveal<cr>')
end

return M
