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

----------------------------------------------------------------------
--        use lsp-installer only to handle lsps that is not         --
--                easy to setup from system package                 --
----------------------------------------------------------------------

local M = {}

function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  if vim.fn.has('mac') ~= 1 and vim.fn.has('unix') ~= 1 then
    vim.api.nvim_notify('Unsupported system', 3, {})
    return
  end

  -- TODO: if a lsp server is not available (command not found), install and setup via lsp-installer
  local lsp_basic = require('aceforeverd.config.lsp-basic')

  local general_lsp_config = lsp_basic.general_cfg

  local setup_generalized_with_cfg_override = function(cfg_override)
    return function(server)
      server:setup(vim.tbl_deep_extend('force', general_lsp_config, cfg_override))
    end
  end

  -- for those do not need extra configs in lsp-config setup, use this generalized one
  local setup_generalized = function(server)
    server:setup(general_lsp_config)
  end

  local setup_sumeko_lua = function(server)
    local luadev = require('lua-dev').setup({
      runtime_path = true, -- it will be slow
      -- add any options here, or leave empty to use the default settings
      lspconfig = general_lsp_config,
    })

    -- vim.api.nvim_notify(require('luaunit').prettystr(luadev), 2, {})

    server:setup(luadev)
  end

  local html_cfg = {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = { snippetSupport = true },
        },
      },
    },
  }

  local setup_lsp_configs = {
    sumneko_lua = setup_sumeko_lua,
    diagnosticls = setup_generalized_with_cfg_override(require('aceforeverd.plugins.lsp.diagnosticls').get_config()),
    yamlls = setup_generalized_with_cfg_override({
      settings = {
        yaml = {
          schemas = {
            ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
          },
        },
      },
    }),
    html = setup_generalized_with_cfg_override(html_cfg),
    cssls = setup_generalized_with_cfg_override(html_cfg),
    jsonls = setup_generalized_with_cfg_override(vim.tbl_deep_extend('force', html_cfg, {
      commands = {
        JsonFormat = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
          end,
        },
      },
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      },
    })),
    bashls = setup_generalized,
    pyright = setup_generalized,
    cmake = setup_generalized,
    lemminx = setup_generalized,
    vimls = setup_generalized,
    dockerls = setup_generalized,
    tailwindcss = setup_generalized,
    tsserver = setup_generalized,
  }

  -- pre-installed lsp server managed by nvim-lsp-installer, installed in stdpath('data')
  local lsp_installer = require('nvim-lsp-installer')
  lsp_installer.on_server_ready(function(server)
    local setup_func = setup_lsp_configs[server.name]
    if setup_func ~= nil then
      setup_func(server)
    end
  end)
end

return M
