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

-- TODO: if a lsp server is not available (command not found), prompt install and setup via lsp-installer
-- like this:
--[[
  local lsp_installer_servers = require('nvim-lsp-installer.servers')
  local available, server = lsp_installer_servers.get_server('jdtls')

  if not available then
    vim.api.nvim_notify('jdtls not available from lsp-installer, install manually', 3, {})
    return ''
  end

  if not server:is_installed() then
    vim.api.nvim_notify('installing jdtls via lsp-installer', 2, {})
    server:install()
  end
]]
M.general_lsp_config = require('aceforeverd.lsp.common').general_cfg

function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  if vim.fn.has('mac') ~= 1 and vim.fn.has('unix') ~= 1 then
    vim.api.nvim_notify('Unsupported system', 3, {})
    return
  end

  local general_lsp_config = M.general_lsp_config

  local setup_generalized_with_cfg_override = function(cfg_override)
    if type(cfg_override.on_attach) == 'function' then
      -- extend the function
      local extra_on_attach = cfg_override.on_attach
      cfg_override.on_attach = function(client, bufnr)
        general_lsp_config.on_attach(client, bufnr)
        extra_on_attach(client, bufnr)
      end
    end

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
      runtime_path = false, -- true -> it will be slow
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
    diagnosticls = setup_generalized_with_cfg_override(require('aceforeverd.lsp.diagnosticls').get_config()),
    yamlls = setup_generalized_with_cfg_override({
      settings = {
        yaml = {
          schemas = {
            -- check default in https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
            ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            ['https://json.schemastore.org/prometheus.json'] = { 'prometheus*.yml', 'prometheus*.yaml' },
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
    sqls = setup_generalized_with_cfg_override({
      on_attach = function(client, bufnr)
        require('sqls').on_attach(client, bufnr)
      end,
    }),
    remark_ls = setup_generalized,
    rust_analyzer = M.setup_rust_analyzer,
    codeqlls = setup_generalized,
    taplo = setup_generalized,
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

function M.setup_rust_analyzer(server)
  local rust_analyzer_opts = vim.tbl_deep_extend(
    'force',
    server:get_default_options(),
    require('aceforeverd.lsp.common').general_cfg
  )

  require('rust-tools').setup({
    server = rust_analyzer_opts,
  })
end

return M
