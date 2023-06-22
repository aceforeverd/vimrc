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

--[[ diagnostic language server configurations ]]

local M = {}

-- https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
function M.get_config()
  return {
    filetypes = { 'cpp' },
    init_options = {
      linters = {
        vint = {
          command = 'vint',
          debounce = 100,
          args = { '--enable-neovim', '--no-color', '-' },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = 'vint',
          rootPatterns = {'.vintrc.yml', '.git'},
          formatLines = 1,
          formatPattern = {
            '[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$',
            {
              line = 1,
              column = 2,
              message = 3,
            },
          },
        },
        cpplint = {
          command = 'cpplint',
          args = { '%file' },
          debounce = 100,
          isStderr = true,
          isStdout = false,
          sourceName = 'cpplint',
          offsetLine = 0,
          offsetColumn = 0,
          rootPatterns = { 'CPPLINT.cfg', '.git' },
          formatPattern = {
            '^[^:]+:(\\d+):(\\d+)?\\s+(.+?)\\s\\[(\\d)\\]$',
            {
              line = 1,
              column = 2,
              message = 3,
              security = 4,
            },
          },
          securities = {
            [1] = 'info',
            [2] = 'warning',
            [3] = 'warning',
            [4] = 'warning',
            [5] = 'error',
          },
          requiredFiles = {'CPPLINT.cfg'}
        },
        shellcheck = {
          command = 'shellcheck',
          debounce = 100,
          args = {
            '--format',
            'json',
            '-',
          },
          sourceName = 'shellcheck',
          parseJson = {
            line = 'line',
            column = 'column',
            endLine = 'endLine',
            endColumn = 'endColumn',
            message = '${message} [${code}] (diagnostic/shellcheck)',
            security = 'level',
          },
          securities = {
            error = 'error',
            warning = 'warning',
            info = 'info',
            style = 'hint',
          },
        },
        actionlint = {
          command = 'actionlint',
          args = { '%file' },
          debounce = 100,
          sourceName = 'actionlint',
          rootPatterns = { '.github' },
          ignore = { '/*', '!/.github', '/.github/*', '!/.github/workflows' },
          formatPattern = {
            '^[^:]+:(\\d+):(\\d+):\\s+(.+)$',
            {
              line = 1,
              column = 2,
              message = 3,
            },
          },
        },
        pylint = {
          sourceName = 'pylint',
          command = 'pylint',
          debounce = 500,
          rootPatterns = { 'pylintrc', 'pyproject.toml', 'setup.py', '.git' },
          args = {
            '-f',
            'json',
            -- --from-stdin have more accurate reports like correct endColumn information
            '--from-stdin',
            '%filename',
          },
          -- offset added to the line and column reported by linter
          -- vim's line and column start from 1
          -- so if the line & column reported is zero-based, it need `offsetColumn = 1` to be added
          offsetLine = 0,
          offsetColumn = 1,
          parseJson = {
            line = 'line',
            column = 'column',
            endLine = 'endLine',
            endColumn = 'endColumn',
            security = 'type',
            message = '[${message-id} <${symbol}>]: ${message} (diagnostic/pylint)',
          },
          securities = {
            informational = 'hint',
            refactor = 'info',
            convention = 'info',
            warning = 'warning',
            error = 'error',
            fatal = 'error',
          },
        },
      },
      filetypes = {
        vim = { 'vint' },
        sh = { 'shellcheck' },
        cpp = { 'cpplint' },
        yaml = { 'actionlint' },
        python = { 'pylint' }, -- disabled
      },
      formatters = {},
      formatFiletypes = {},
    },
  }
end

return M
