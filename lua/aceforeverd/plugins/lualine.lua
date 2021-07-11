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
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'material',
    component_separators = { '', '' },
    section_separators = { '', '' },
    disabled_filetypes = { 'coc-explorer' }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { { 'filename', file_status = true }, 'coc#status' },
    lualine_x = { 'b:coc_current_function', 'filetype', 'fileformat', 'encoding' },
    lualine_y = {
      {
        'diagnostics',
        sources = { 'coc' },
        -- displays diagnostics from defined severity
        sections = { 'error', 'warn', 'info', 'hint' },
        -- all colors are in format #rrggbb
        color_error = nil, -- changes diagnostic's error foreground color
        color_warn = nil, -- changes diagnostic's warn foreground color
        color_info = nil, -- Changes diagnostic's info foreground color
        color_hint = nil, -- Changes diagnostic's hint foreground color
        symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
      }
    },
    lualine_z = { 'location', 'progress' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype', 'fileformat', 'encoding' },
    lualine_y = {
      {
        'diagnostics',
        sources = { 'coc' },
        -- displays diagnostics from defined severity
        sections = { 'error', 'warn', 'info', 'hint' },
        -- all colors are in format #rrggbb
        color_error = nil, -- changes diagnostic's error foreground color
        color_warn = nil, -- changes diagnostic's warn foreground color
        color_info = nil, -- Changes diagnostic's info foreground color
        color_hint = nil, -- Changes diagnostic's hint foreground color
        symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
      }
    },
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive', 'fzf' }
}
