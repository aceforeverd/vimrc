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

-- general status line component provider

local M = {}

function M.gps()
    if require("nvim-gps").is_available() then
        return require("nvim-gps").get_location()
    end
    local text = require("nvim-treesitter").statusline({ indicator_size = 40 })
    if text then
        return text
    else
        return ""
    end
end

function M.indent()
    return 'IN:' .. tostring(vim.fn.indent(vim.fn.line('.'))) .. '/' ..
        tostring(vim.o.shiftwidth)
end

function M.file_size()
    -- credit: feline.nvim
    local suffix = {'b', 'k', 'M', 'G', 'T', 'P', 'E'}
    local index = 1

    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))

    if fsize < 0 then fsize = 0 end

    while fsize > 1024 and index < 7 do
        fsize = fsize / 1024
        index = index + 1
    end

    return string.format(index == 1 and '%g%s' or '%.2f%s', fsize, suffix[index])
end

return M
