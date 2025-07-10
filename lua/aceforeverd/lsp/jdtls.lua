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

--- get JDK major name by sdkman install directory
---@param dir string
---@return number|nil
local function jdk_major_version(dir)
  local basename = vim.fs.basename(dir)
  local version = nil
  for v in string.gmatch(basename, '%d+') do
    version = v
    break
  end

  return tonumber(version)
end

local function get_mason_package(pkg_name)
  return vim.fn.expand("$MASON/packages/" .. pkg_name)
end

local function cfg_file()
  if vim.fn.has('mac') == 1 then
    return 'config_mac'
  elseif vim.fn.has('unix') == 1 then
    return 'config_linux'
  else
    vim.notify('Unsupported system', vim.log.levels.ERROR, {})
    return nil
  end
end

--- extract major version of java exe
--- @return number|nil
local function extract_jdk_major(java_exe)
  if vim.uv.fs_stat(java_exe) == nil then
    return nil
  end

  local out = vim.fn.systemlist({ java_exe, '--version' })
  if #out == 0 then
    return nil
  end
  local version_line = out[1]
  local matches = vim.fn.matchlist(version_line, [[\v(\d+)\.(\d+)\.(\d+(_\d+)?)]])
  if #matches < 2 then
    return nil
  end

  return tonumber(matches[2])
end

--- valid if the java is sufficient to run jdtls
---@param major number|nil jdk major version
---@return boolean
local function valid_java_version(major)
  return major ~= nil and major >= 21
end

--- search system JDK
---@return {path: string, major: number} | nil
local function search_system_jdk()
  local java_exe = ''
  local java_home = os.getenv('JAVA_HOME')
  if java_home ~= nil then
    -- 2. search $JAVA_HOME
    java_exe = java_home .. '/bin/java'
  else
    -- 3. search system
    java_exe = vim.fn.exepath('java')
    -- extract realpath for java home
    java_home = vim.fs.dirname(vim.fs.dirname(vim.uv.fs_realpath(java_exe)))
  end
  if java_exe == nil then
    return nil
  end

  local major = extract_jdk_major(java_exe)
  if major == nil then
    return nil
  end
  return { major = major, path = java_home }
end


--- search JDK sufficient running jdtls. Currently we looking for jdks in sdkamn and system wide
--- @return string|nil # sufficient jdk path if found
local function search_jdk_for_jdtls()
  -- 1. search user sdkman installation
  local javas = vim.fn.glob('~/.sdkman/candidates/java/{21,22,23}*', true, true)
  if #javas > 0 then
    return javas[1]
  else
    local stat = search_system_jdk()
    if stat ~= nil and valid_java_version(stat.major) then
      return stat.path
    end
  end

  return nil
end

--- generate the runtime name for jdtls
---@param major number
local function runtime_name(major)
  -- https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- name is NOT arbitrary, go link above and search 'enum ExecutionEnvironment'

  if major == 8 then
    return 'JavaSE-1.8'
  end

  return 'JavaSE-' .. major
end

local function search_jdk_runtimes()
  local runtimes = {}
  local sdkman_java_candidates = '~/.sdkman/candidates/java/'
  local paths = vim.fn.glob(sdkman_java_candidates .. '*', true, true)
  for _, jdk_path in ipairs(paths) do
    local version = jdk_major_version(jdk_path)
    if version ~= nil then
      table.insert(runtimes, { name = runtime_name(version), path = jdk_path })
    end
  end

  if #runtimes == 0 then
    -- system jdk as fallback
    if vim.fn.executable('java-config') == 1 then
      -- system default
      local system_default = vim.fn.system({ 'java-config', '-O' })
      if vim.v.shell_error == 0 and system_default ~= nil then
        local ver = extract_jdk_major(string.gsub(system_default, '%s+', '') .. '/bin/java')
        if ver ~= nil then
          table.insert(runtimes, { name = runtime_name(ver), path = string.gsub(system_default, '%s+$', '') })
        end
      end
    else
      local stat = search_system_jdk()
      if stat ~= nil then
        table.insert(runtimes, { name = runtime_name(stat.major), path = stat.path })
      end
    end
  end

  return runtimes
end

local jdtls_actions = {
  n = {
    { name = 'organize imports',   action = function() require('jdtls').organize_imports() end, },
    { name = 'extract variable',   action = function() require('jdtls').extract_variable() end, },
    { name = 'extract constant',   action = function() require('jdtls').extract_constant() end },
    { name = 'test class',         action = function() require('jdtls').test_class() end },
    { name = 'test nearest class', action = function() require('jdtls').test_nearest_method() end },
  },
  x = {
    { name = 'extract variable', action = function() require('jdtls').extract_variable(true) end },
    { name = 'extract constant', action = function() require('jdtls').extract_constant(true) end },
    { name = 'extract method',   action = function() require('jdtls').extract_method(true) end },
  },
}

local function call_jdtls_actions(mode)
  vim.ui.select(jdtls_actions[mode], {
    prompt = 'Jdtls Actions',
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice ~= nil then
      choice.action()
    end
  end)
end

local function lombok_jvm_args(dir)
  local lomboks = vim.fn.glob(dir .. "/lombok*.jar", true, true)
  if #lomboks > 0 then
    local lombok_file = lomboks[1]
    return {
      "-javaagent:" .. lombok_file,
      "-Xbootclasspath/a:" .. lombok_file,
    }
  end

  return {}
end

function M.jdtls()
  local mason_registery = require('mason-registry')
  local server = mason_registery.get_package('jdtls')

  if not server:is_installed() then
    vim.notify('installing jdtls via mason', vim.log.levels.INFO, {})
    server:install()
  end

  -- dir should be absolute path
  local dir = get_mason_package('jdtls')

  local jdtls = require('jdtls')
  local prj_root = require('aceforeverd.util').detect_root({
    { '.jdtls-root' },
    { 'mvnw',       'mvnw.cmd',    'gradlew', 'gradlew.bat' },
    { 'pom.xml',    'build.gradle' },
    { '.git' },
  })

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  -- Switching to standard LSP progress events (as soon as it lands, see link)
  -- https://github.com/eclipse/eclipse.jdt.ls/pull/2030#issuecomment-1210815017
  extendedClientCapabilities.progressReportProvider = false

  local config_path = vim.fn.stdpath('config')
  local jdtls_workspace_prefix = vim.fn.stdpath('cache')

  -- create the project data directory by the full path of java project
  local prj_name = vim.fn.substitute(vim.fn.fnamemodify(prj_root, ':p:h'), [[/\|\\\|\ \|:\|\.]], '', 'g')
  local workspace_dir = jdtls_workspace_prefix .. '/jdtls-ws/' .. prj_name

  local general_cfg = require('aceforeverd.lsp.common').general_cfg

  general_cfg.on_attach = function(client, bufnr)
    require('aceforeverd.lsp.common').on_attach(client, bufnr)

    -- jdtls defined maps
    vim.keymap.set('n', '<leader>jj', function()
      call_jdtls_actions('n')
    end, { buffer = bufnr, noremap = true, desc = 'jdtls action' })
    vim.keymap.set('x', '<leader>jj', function()
      call_jdtls_actions('x')
    end, { buffer = bufnr, noremap = true, desc = 'jdtls action' })
  end

  local maybe_java_home = search_jdk_for_jdtls()
  if maybe_java_home == nil then
    vim.notify('no sufficient JDK found for jdtls, hint jdtls require jdk >= 21', vim.log.levels.WARN, {})
    return
  else
    vim.notify(string.format('selected JDK "%s" for jdtls', maybe_java_home), vim.log.levels.INFO, {})
  end
  local cmd = { 'jdtls', '-data', workspace_dir, '--java-executable', maybe_java_home .. '/bin/java' }
  local lombok_args = lombok_jvm_args(dir)
  for _, value in ipairs(lombok_args) do
    table.insert(cmd, '--jvm-arg=' .. value)
  end
  if vim.g.jdtls_legacy_script then
    cmd = {
      config_path .. '/bin/java-lsp',
      '-r', dir,
      '-c', dir .. '/' .. cfg_file(),
      '-d', workspace_dir,
      '-j', maybe_java_home,
    }
  end

  local config = vim.tbl_deep_extend('force', {
    cmd = cmd,
    settings = {
      -- https://github.com/mfussenegger/dotfiles/blob/master/vim/.config/nvim/ftplugin/java.lua
      java = {
        autobuild = { enabled = false },
        maxConcurrentBuilds = 8,
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        saveActions = {
          organizeImports = false,
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
      bundles = {},
      extendedClientCapabilities = extendedClientCapabilities
    },
    -- TODO: add more mappings from nvim-jdtls

    root_dir = prj_root,
  }, general_cfg)

  local java_test = mason_registery.get_package('java-test')
  if java_test:is_installed() then
    local java_test_jars = vim.fn.glob(get_mason_package('java-test') .. '/extension/server/*.jar', true, true)
    for _, value in ipairs(java_test_jars) do
      table.insert(config.init_options.bundles, value)
    end
  end

  local java_debug = mason_registery.get_package('java-debug-adapter')
  if java_debug:is_installed() then
    local java_debug_jars =
        vim.fn.glob(get_mason_package('java-debug-adapter') .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true,
          true)
    for _, value in ipairs(java_debug_jars) do
      table.insert(config.init_options.bundles, value)
    end
  end

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
