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

local general_lsp_config = require('aceforeverd.lsp.common').general_cfg

local html_cfg = {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = { snippetSupport = true },
      },
    },
  },
}

local no_cfg = 0

return {
  clangd = function()
    local on_attach = general_lsp_config.on_attach

    local lsp_status = require('lsp-status')

    local clangd_handlers =
      vim.tbl_deep_extend('error', general_lsp_config.handlers, lsp_status.extensions.clangd.setup())
    -- use lsp-status's handler, disabling fidget
    clangd_handlers['$/progress'] =
      require('lsp-status.util').mk_handler(require('lsp-status.messaging').progress_callback)

    return {
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
          '<Leader>av',
          '<c-w>v<cmd>ClangdSwitchSourceHeader<cr>',
          { noremap = true, silent = true, buffer = bufnr, desc = 'switch source (vsplit)' }
        )
        vim.keymap.set(
          'n',
          '<Leader>as',
          '<c-w>s<cmd>ClangdSwitchSourceHeader<cr>',
          { noremap = true, silent = true, buffer = bufnr, desc = 'switch source (split)' }
        )

        -- use lsp-status only for clangd
        -- clangd file status is not LSP [progress protocal](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workDoneProgress) so only lsp-status handle it
        lsp_status.on_attach(client)
      end,
      capabilities = {
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
        offsetEncoding = { 'utf-16' },
      },
      handlers = clangd_handlers,
      init_options = { clangdFileStatus = true },
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--all-scopes-completion',
        '--header-insertion-decorators',
        '--enable-config',
      },
    }
  end,
  lua_ls = {
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
  },
  yamlls = require('aceforeverd.lsp.yaml').lsp_cfg,
  html = html_cfg,
  cssls = html_cfg,
  jsonls = vim.tbl_deep_extend('force', html_cfg, {
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
  }),
  bashls = no_cfg,
  pyright = no_cfg,
  neocmake = no_cfg,
  lemminx = no_cfg,
  vimls = no_cfg,
  dockerls = no_cfg,
  tailwindcss = no_cfg,
  ts_ls = no_cfg,
  -- remark_ls = no_cfg,
  taplo = no_cfg,
  jsonnet_ls = no_cfg,
  docker_compose_language_service = {
    filetypes = { 'yaml.docker-compose' },
    root_dir = require('lspconfig.util').root_pattern('docker-compose*.yml', 'docker-compose*.yaml'),
  },
  diagnosticls = require('aceforeverd.lsp.diagnosticls').get_config(),
}
