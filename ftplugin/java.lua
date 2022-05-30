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

-- dir should be absolute path
local dir = server.root_dir

local jdtls = require('jdtls')
local root_marks = { 'mvnw', 'gradlew', 'pom.xml', '.git' }
local prj_root = require('jdtls.setup').find_root(root_marks)

local extendedClientCapabilities = jdtls.extendedClientCapabilities;
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;

-- TODO: check java version is jdk 11 or later

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
    -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L1-L149
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
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
