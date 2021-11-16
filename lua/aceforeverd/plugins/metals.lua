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
    local metals = require('metals')
    local metals_config = metals.bare_config()
    metals_config.init_options.statusBarProvider = "on"
    metals_config.on_attch = require('aceforeverd.config.lsp-basic').on_attach
    metals_config.capabilities = require('aceforeverd.config.lsp-basic').capabilities

    metals.initialize_or_attach(metals_config)
end

return M
