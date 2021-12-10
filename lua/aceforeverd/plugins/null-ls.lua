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
    local null_ls = require('null-ls')

    local sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.cmake_format,
        null_ls.builtins.formatting.eslint,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,

        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.vint.with({
            args = { "--enable-neovim", "-s", "-j", "$FILENAME" }
        })
    }

    null_ls.config({ sources = sources})

    require("lspconfig")["null-ls"].setup({
        on_attach = require('aceforeverd.config.lsp-basic').on_attach,
        capabilities = require('aceforeverd.config.lsp-basic').capabilities
    })
end

return M
