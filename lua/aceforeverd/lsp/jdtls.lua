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

local M = {}

function M.jdtls()
  local mason_registery = require('mason-registry')
  local server = mason_registery.get_package('jdtls')

  if not server:is_installed() then
    vim.api.nvim_notify('installing jdtls via lsp-installer', 2, {})
    server:install()
  end

  -- dir should be absolute path
  local dir = server:get_install_path()

  local jdtls = require('jdtls')
  local root_marks = { 'mvnw', 'gradlew', 'pom.xml', '.git' }
  local prj_root = require('jdtls.setup').find_root(root_marks)

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  -- TODO: check java version, jdtls requires JAVA >= 17

  local cfg_file
  if vim.fn.has('mac') == 1 then
    cfg_file = 'config_mac'
  elseif vim.fn.has('unix') == 1 then
    cfg_file = 'config_linux'
  else
    vim.api.nvim_notify('Unsupported system', 4, {})
    return
  end

  local config_path = vim.fn.stdpath('config')
  local data_path = vim.fn.stdpath('data')

  -- create the project data directory by the full path of java project
  local prj_name = vim.fn.substitute(vim.fn.fnamemodify(prj_root, ':p:h'), [[/\|\\\|\ \|:\|\.]], '', 'g')
  local workspace_dir = data_path .. '/jdtls-ws/' .. prj_name

  local config = vim.tbl_deep_extend('force', {
    cmd = { config_path .. '/bin/java-lsp', dir, dir .. '/' .. cfg_file, workspace_dir },
    settings = {
      -- https://github.com/mfussenegger/dotfiles/blob/master/vim/.config/nvim/ftplugin/java.lua
      java = {
        autobuild = { enabled = false },
        maxConcurrentBuilds = 8,
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        saveActions = {
          organizeImports = true,
        },
        completion = {
          favoriteStaticMembers = {
            "io.crate.testing.Asserts.assertThat",
            "org.assertj.core.api.Assertions.assertThat",
            "org.assertj.core.api.Assertions.assertThatThrownBy",
            "org.assertj.core.api.Assertions.assertThatExceptionOfType",
            "org.assertj.core.api.Assertions.catchThrowable",
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
          filteredTypes = {
            'com.sun.*',
            'io.micrometer.shaded.*',
            'java.awt.*',
            'jdk.*',
            'sun.*',
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
          hashCodeEquals = {
            useJava7Objects = true,
          },
          useBlocks = true,
        },
        -- runtimes = {
        -- },
      },
    },
    flags = {
      allow_incremental_sync = true,
    },
    init_options = {
      extendedClientCapabilities = extendedClientCapabilities
    },
    -- TODO: add more mappings from nvim-jdtls

    root_dir = prj_root,
  }, require('aceforeverd.lsp.common').general_cfg)

  require('jdtls').start_or_attach(config)
end

function M.setup()
  local nvim_jdtls_group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "java" },
    callback = function() M.jdtls() end,
    group = nvim_jdtls_group,
  })
end

return M
