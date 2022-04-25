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

function M.get_config()
  return {
    filetypes = { 'cpp', 'yaml', 'sh', 'vim' },
    init_options = {
      linters = {
        vint = {
          command = 'vint',
          debounce = 100,
          args = { '--enable-neovim', '--no-color', '-' },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = 'vint',
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
          requiredFiles = {
            -- diagnostic lsp seems check files in directory same with the edit buffer instead the detected project root
            -- so this is kind hack for general use (up to four depth)
            'CPPLINT.cfg',
            '../CPPLINT.cfg',
            '../../CPPLINT.cfg',
            '../../../CPPLINT.cfg',
            '../../../../CPPLINT.cfg',
          },
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
            message = '${message} [${code}]',
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
      },
      filetypes = {
        vim = { 'vint' },
        sh = { 'shellcheck' },
        cpp = { 'cpplint' },
        yaml = { 'actionlint' },
      },
      formatters = {},
      formatFiletypes = {},
    },
  }
end

return M
