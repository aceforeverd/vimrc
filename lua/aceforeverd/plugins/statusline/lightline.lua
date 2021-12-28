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
  vim.g.lightline = {
    colorscheme = 'deus',
    enabled = {
      statusline = 1,
      tabline = 0,
    },
    active = {
      left = {
        { 'mode', 'paste', 'git_branch' },
        { 'readonly', 'modified', 'git_diff' },
        { 'lsp_status' },
      },
      right = {
        { 'lineinfo', 'percent', 'file_size' },
        { 'fileencoding', 'fileformat', 'spell' },
        { 'gps', 'filetype' },
      },
    },
    inactive = {
      left = { { 'filename' } },
      right = { { 'lineinfo' }, { 'percent' } },
    },
    component = {
      total_line = '%L',
    },
    component_function = {
      gps = [[aceforeverd#statusline#nvim_gps]],
      lsp_status = [[aceforeverd#statusline#lsp_status]],
      git_branch = [[FugitiveHead]],
      git_diff = [[aceforeverd#statusline#git_diff]],
      file_size = [[aceforeverd#statusline#file_size]],
    },
  }
end

return M
