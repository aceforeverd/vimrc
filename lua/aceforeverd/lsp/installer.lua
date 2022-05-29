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

--- setup lsp servers managed by lsp-installer
--- find lsp executable from installer first, and fallback to normal path if not
function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  if vim.fn.has('mac') ~= 1 and vim.fn.has('unix') ~= 1 then
    vim.api.nvim_notify('Unsupported system', 3, {})
    return
  end

  local lspconfig = require('lspconfig')

  -- Two helper functions provided
  --  1. setup_generalized
  --  2. setup_generalized_with_override
  -- to help setup lsp directly with nvim-lspconfig
  -- If a lsp enhancement plugin exists, e.g rust-tools, use that tool setup lsp instead

  -- for those do not need extra configs in lsp-config setup, use this generalized one
  local setup_generalized = function(name)
    lspconfig[name].setup(M.general_lsp_config)
  end

  -- override default lsp setup function by lsp-installer
  -- @param cfg_override lsp configuration override, can be
  --   1. table
  --   2. function: return the override table
  -- @param post_hook additional action take after lsp setup, only support function type with one parameter that is lsp-installer's server
  local setup_generalized_with_override = function(cfg_override, post_hook)
    return function(server_name)
      local override = {}
      if type(cfg_override) == 'table' then
        if type(cfg_override.on_attach) == 'function' then
          -- extend the function
          local extra_on_attach = cfg_override.on_attach
          if type(extra_on_attach) == 'function' then
            cfg_override.on_attach = function(client, bufnr)
              M.general_lsp_config.on_attach(client, bufnr)
              extra_on_attach(client, bufnr)
            end
          end
        end
        override = vim.tbl_deep_extend('force', M.general_lsp_config, cfg_override)
      elseif type(cfg_override) == 'function' then
        override = vim.tbl_deep_extend('force', M.general_lsp_config, cfg_override())
      elseif type(cfg_override) == 'nil' then
        override = M.general_lsp_config
      end

      lspconfig[server_name].setup(override)

      if type(post_hook) == 'function' then
        post_hook(server_name)
      end
    end
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
    sumneko_lua = setup_generalized_with_override(function()
      return require('lua-dev').setup({
        runtime_path = false, -- true -> it will be slow
        -- add any options here, or leave empty to use the default settings
        lspconfig = M.general_lsp_config,
      })
    end),
    diagnosticls = setup_generalized_with_override(require('aceforeverd.lsp.diagnosticls').get_config()),
    yamlls = setup_generalized_with_override({
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
    html = setup_generalized_with_override(html_cfg),
    cssls = setup_generalized_with_override(html_cfg),
    jsonls = setup_generalized_with_override(vim.tbl_deep_extend('force', html_cfg, {
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
    sqls = setup_generalized_with_override({
      on_attach = function(client, bufnr)
        require('sqls').on_attach(client, bufnr)
      end,
    }),
    -- remark_ls = setup_generalized,
    codeqlls = setup_generalized_with_override(function()
      local lsp_installer_servers = require('nvim-lsp-installer.servers')
      local available, server = lsp_installer_servers.get_server('codeqlls')
      if available then
        return {
          settings = {
            search_path = server.root_dir,
          },
        }
      else
        return {}
      end
    end),
    taplo = setup_generalized,
    jsonnet_ls = setup_generalized,
  }

  -- pre-installed lsp server managed by nvim-lsp-installer, installed in stdpath('data')
  require('nvim-lsp-installer').setup({
    automatic_installation = false,
  })

  for name, fn in pairs(setup_lsp_configs) do
    fn(name)
  end
end

return M
