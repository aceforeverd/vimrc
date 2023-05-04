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
    -- null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.eslint,
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { '-i', '4' },
    }),
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.protolint,
    null_ls.builtins.formatting.yapf,
    null_ls.builtins.formatting.cmake_format,

    null_ls.builtins.diagnostics.protolint.with({
      extra_args = { '--config_path', vim.fn.stdpath('config') .. '/.protolint.yaml' },
    }),
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.checkmake,
    null_ls.builtins.diagnostics.pylint.with({
      condition = function(utils)
        -- too many reports by pylint, enable only required
        return utils.root_has_file({ "pylintrc", ".pylintrc" })
      end,
      diagnostics_postprocess = function(diagnostics)
        diagnostics.message = string.format(
          '[%s <%s>]: %s (%s/null-ls)]',
          diagnostics.code,
          diagnostics.symbol,
          diagnostics.message,
          diagnostics.source
        )
      end,
    }),
    -- diagnosticls take those
    -- null_ls.builtins.diagnostics.shellcheck,
  }

  null_ls.setup({
    sources = sources,
    diagnostics_format = '[#{c}] #{m} (#{s}/null-ls)',
    on_attach = require('aceforeverd.lsp.common').on_attach,
    -- handlers not work
    handlers = require('aceforeverd.lsp.common').handlers,
  })
end

return M
