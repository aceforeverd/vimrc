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
local lualine = require('lualine')

local M = {}

function M.setup()
  lualine.setup(vim.tbl_deep_extend('force', lualine.get_config(), {
    options = { theme = 'powerline_dark' },
    sections = {
      lualine_b = { 'branch', 'diff', { 'diagnostics', diagnostics_color = { hint = { fg = '#108080' }, warn = { fg = '#e5c463' } } }},
      lualine_c = { [[require('lsp-status').status()]] },
      lualine_x = {
        { [[require('aceforeverd.utility.statusline').gps()]], color = { fg = '#fda5b4' } },
        'filetype',
        { [[require('aceforeverd.utility.statusline').indent()]] },
        {
          'vim.bo.spelllang',
          cond = function()
            return vim.wo.spell == true
          end,
        },
        'encoding',
      },
      lualine_y = { 'fileformat', 'location' },
      lualine_z = { 'progress', 'filesize' },
    },
    extensions = { 'quickfix', 'fugitive' },
  }))
end

return M
