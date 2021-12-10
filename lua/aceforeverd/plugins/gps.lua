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
    require("nvim-gps").setup({
        icons = {
            ["class-name"] = ' ', -- Classes and class-like objects
            ["function-name"] = ' ', -- Functions
            ["method-name"] = ' ', -- Methods (functions inside class-like objects)
            ["container-name"] = ' ', -- Containers (example: lua tables)
            ["tag-name"] = '炙', -- Tags (example: html tags)
        },
        separator = ' > ',
    })
end

return M
