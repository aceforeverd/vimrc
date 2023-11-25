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


local function search_jdk_runtimes()
  local runtimes = {}
  local sdkman_java_candidates = '~/.sdkman/candidates/java/'
  local jdk_versions = { '8', '11', '17', '21', '22', '18' }
  for _, version in ipairs(jdk_versions) do
    local paths = vim.fn.glob(sdkman_java_candidates .. version .. '.*', true, true)
    for _, jdk_path in ipairs(paths) do
      -- https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- name is NOT arbitrary, go link above and search 'enum ExecutionEnvironment'
      if version ~= '8' then
        table.insert(runtimes, { name = 'JavaSE-' .. version, path = jdk_path })
      else
        table.insert(runtimes, { name = 'JavaSE-1.8', path = jdk_path })
      end
    end
  end

  if vim.fn.executable('java-config') == 1 then
    -- system default
    local system_default = vim.fn.system({ 'java-config', '-O' })
    if vim.v.shell_error == 0 and system_default ~= nil then
      -- TODO: extract jdk version
      table.insert(runtimes, { name = 'JavaSE-17', path = string.gsub(system_default, '%s+$', '') })
    end
  end

  return runtimes
end

-- TODO: setup java-debug & vscode-java-test & nvim-dap
-- they can install via mason

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
  -- Switching to standard LSP progress events (as soon as it lands, see link)
  -- https://github.com/eclipse/eclipse.jdt.ls/pull/2030#issuecomment-1210815017
  extendedClientCapabilities.progressReportProvider = false

  -- Finding supported Java in sdkman
  -- or u can search in more locations
  local javas = vim.fn.glob('~/.sdkman/candidates/java/{21,20,17,22,18,19}*', true, true)
  local java_home
  if #javas > 0 then
    java_home = javas[1]
  else
    java_home = os.getenv('JAVA_HOME')
  end
  -- TODO: build a JDK table dynamically to 'settings.java.configuration' ?

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
    cmd = {
      config_path .. '/bin/java-lsp',
      '-r', dir,
      '-c', dir .. '/' .. cfg_file,
      '-d', workspace_dir,
      '-j', java_home,
    },
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
        configuration = {
          runtimes = search_jdk_runtimes(),
        }
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
