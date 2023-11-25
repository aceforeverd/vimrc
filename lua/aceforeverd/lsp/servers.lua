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

-- LSP server configurations

local lspconfig = require('lspconfig')
local general_lsp_config = require('aceforeverd.lsp.common').general_cfg

-- for those do not need extra configs in lsp-config setup, use this generalized one
local function setup_generalized(name)
  lspconfig[name].setup(general_lsp_config)
end

-- @param cfg_override lsp configuration override, can be
--   1. table
--   2. function: return the override table
local function setup_generalized_with_override(cfg_override)
  return function(server_name)
    local override = {}
    if type(cfg_override) == 'table' then
      if type(cfg_override.on_attach) == 'function' then
        -- extend the function
        local extra_on_attach = cfg_override.on_attach
        if type(extra_on_attach) == 'function' then
          cfg_override.on_attach = function(client, bufnr)
            general_lsp_config.on_attach(client, bufnr)
            extra_on_attach(client, bufnr)
          end
        end
      end
      override = vim.tbl_deep_extend('force', general_lsp_config, cfg_override)
    elseif type(cfg_override) == 'function' then
      override = vim.tbl_deep_extend('force', general_lsp_config, cfg_override())
    elseif type(cfg_override) == 'nil' then
      override = general_lsp_config
    end

    lspconfig[server_name].setup(override)
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

return {
  clangd = function(name)
    local on_attach = general_lsp_config.on_attach
    local capabilities = general_lsp_config.capabilities

    local lsp_status = require('lsp-status')

    local clangd_caps = vim.tbl_deep_extend('force', capabilities, {
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
      offsetEncoding = { 'utf-16' },
    })

    local clangd_handlers = vim.tbl_deep_extend('error', general_lsp_config.handlers, lsp_status.extensions.clangd.setup())
    -- use lsp-status's handler, disabling fidget
    clangd_handlers['$/progress'] = require('lsp-status.util').mk_handler(require('lsp-status.messaging').progress_callback)

    local clangd_cfg = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.keymap.set(
          'n',
          '<Leader>af',
          '<cmd>ClangdSwitchSourceHeader<cr>',
          { noremap = true, silent = true, buffer = bufnr, desc = 'switch source' }
        )
        vim.keymap.set(
          'n',
          '<C-w>av',
          '<c-w>v<cmd>ClangdSwitchSourceHeader<cr>',
          { noremap = true, silent = true, buffer = bufnr, desc = 'switch source (vsplit)' }
        )
        vim.keymap.set(
          'n',
          '<C-w>as',
          '<c-w>s<cmd>ClangdSwitchSourceHeader<cr>',
          { noremap = true, silent = true, buffer = bufnr, desc = 'switch source (split)' }
        )
        vim.keymap.set(
          'n',
          '<Leader>ai',
          '<cmd>ClangdToggleInlayHints<cr>',
          { noremap = true, silent = true, buffer = bufnr, desc = 'toggle inlay hints' }
        )

        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()

        -- use lsp-status only for clangd
        -- clangd file status is not LSP [progress protocal](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workDoneProgress) so only lsp-status handle it
        lsp_status.on_attach(client)
      end,
      capabilities = clangd_caps,
      handlers = clangd_handlers,
      init_options = { clangdFileStatus = true },
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--all-scopes-completion',
        '--header-insertion-decorators',
        '--enable-config'
      },
    }
    lspconfig[name].setup(clangd_cfg)
  end,
  lua_ls = function(name)
    setup_generalized_with_override({
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })(name)
  end,
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
        validate = { enable = true },
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
  -- remark_ls = setup_generalized,
  taplo = setup_generalized,
  jsonnet_ls = setup_generalized,
  docker_compose_language_service = setup_generalized_with_override({
    filetypes = { 'yaml.docker-compose' },
    root_dir = require('lspconfig.util').root_pattern('docker-compose*.yml', 'docker-compose*.yaml'),
  }),
  diagnosticls = setup_generalized_with_override(require('aceforeverd.lsp.diagnosticls').get_config()),
}
