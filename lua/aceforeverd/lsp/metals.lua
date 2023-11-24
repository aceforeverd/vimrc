-- Copyright (C) 2022  Ace <teapot@aceforeverd.com>
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

-- configuration for filetype specific plugins

local M = {}

function M.metals()
  local metals = require('metals')
  local metals_config = vim.deepcopy(metals.bare_config())
  metals_config.settings = {
    showImplicitArguments = true,
  }
  -- TODO: add message to statusline via vim.g['metals_status']
  metals_config.init_options.statusBarProvider = 'on'

  metals_config = vim.tbl_deep_extend('force', metals_config, require('aceforeverd.lsp.common').general_cfg)

  local dap = require('dap')

  dap.configurations.scala = {
    {
      type = 'scala',
      request = 'launch',
      name = 'RunOrTest',
      metals = {
        runType = 'runOrTestFile',
        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
      },
    },
    {
      type = 'scala',
      request = 'launch',
      name = 'Test Target',
      metals = {
        runType = 'testTarget',
      },
    },
  }

  metals_config.on_attach = function(client, bufnr)
    require('aceforeverd.lsp.common').on_attach(client, bufnr)
    require('metals').setup_dap()
  end

  metals.initialize_or_attach(metals_config)
end

function M.setup()
  local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'scala', 'sbt' },
    callback = function()
      M.metals()
    end,
    group = nvim_metals_group,
  })
end

return M
