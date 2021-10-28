-- Copyright (C) 2021  Ace <teapot@aceforeverd.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- plugins will only load if has('nvim-0.5')
local config_path = vim.fn.expand('<sfile>:p:h')
vim.cmd(string.format("let &packpath = &packpath . ',' . '%s/bundle'", config_path))

local execute = vim.api.nvim_command
local fn = vim.fn

local packer_install_path = config_path .. '/bundle/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(packer_install_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path })
  execute 'packadd packer.nvim'
end

local packer = require('packer')

local util = require('packer.util')
packer.init({
  package_root = util.join_paths(config_path, 'bundle/pack'),
  compile_path = util.join_paths(config_path, 'plugin', 'packer_compiled.vim'),
  plugin_package = 'packer',
  max_jobs = 12,
  git = { clone_timeout = 30 },
  profile = { enable = true, threshold = 1 }
})

return packer.startup({
  function(use)
    use { 'wbthomason/packer.nvim' }

    use { 'neovim/nvim-lspconfig' }

    use { 'williamboman/nvim-lsp-installer' }

    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-emoji',
        'octaltree/cmp-look',
        'ray-x/cmp-treesitter',
        { 'andersevenrud/compe-tmux', branch = 'cmp' }
      },
      config = function() require('aceforeverd.plugins.lsp') end
    }

    use {
      'onsails/lspkind-nvim',
      config = function() require('lspkind').init { with_text = true } end
    }

    use { 'ray-x/lsp_signature.nvim', cond = function() return vim.fn.has('nvim-0.6.0') == 1 end }

    use {
      'kosayoda/nvim-lightbulb',
      config = function()
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
      end,
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end
    }

    use { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' }

    use { 'simrat39/rust-tools.nvim' }

    use {
      'mfussenegger/nvim-jdtls',
      ft = { 'java' },
      config = function()
        require('jdtls').start_or_attach {
          -- The command that starts the language server
          cmd = { 'java', '-Dosgi.bundles.defaultStartLevel=4' },
          -- TODO: add more mappings from nvim-jdtls
          on_attach = require('aceforeverd.config.lsp-basic').on_attach,
          capabilities = require('aceforeverd.config.lsp-basic').capabilities,

          root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' })
        }
      end
    }

    use {
      'RRethy/vim-illuminate',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end,
      config = function()
        vim.api.nvim_exec([[
        augroup illuminate_augroup
          autocmd!
          autocmd VimEnter * highlight illuminatedWord cterm=underline guibg=#5e5e61
        augroup END
        ]], false)
      end
    }

    use {
      'folke/trouble.nvim',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end,
      config = function() require("trouble").setup {} end
    }

    -- neovim builtin lsp status line component
    use { 'nvim-lua/lsp-status.nvim' }

    -- use fzf to display builtin LSP results
    -- use { 'ojroques/nvim-lspfuzzy', config = function() require('lspfuzzy').setup {} end }
    use { 'gfanto/fzf-lsp.nvim', config = function()
      -- vim.lsp.handlers["textDocument/codeAction"] = require('fzf_lsp').code_action_handler
      vim.lsp.handlers["textDocument/definition"] = require('fzf_lsp').definition_handler
      vim.lsp.handlers["textDocument/declaration"] = require('fzf_lsp').declaration_handler
      vim.lsp.handlers["textDocument/typeDefinition"] = require('fzf_lsp').type_definition_handler
      vim.lsp.handlers["textDocument/implementation"] = require('fzf_lsp').implementation_handler
      vim.lsp.handlers["textDocument/references"] = require('fzf_lsp').references_handler
      -- vim.lsp.handlers["textDocument/documentSymbol"] = require('fzf_lsp').document_symbol_handler
      -- vim.lsp.handlers["workspace/symbol"] = require('fzf_lsp').workspace_symbol_handler
      -- vim.lsp.handlers["callHierarchy/incomingCalls"] = require('fzf_lsp').ingoing_calls_handler
      -- vim.lsp.handlers["callHierarchy/outgoingCalls"] = require('fzf_lsp').outgoing_calls_handler
    end }

    use { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }, ft = { 'scala', 'sbt' } }

    use {
      'jose-elias-alvarez/null-ls.nvim',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end
    }

    use { 'mfussenegger/nvim-lint' }

    use {
      'norcalli/nvim-colorizer.lua',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end,
      config = function() require'colorizer'.setup() end
    }

    use { 'nvim-lua/plenary.nvim' }

    use { 'pwntester/codeql.nvim' }

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function() require('aceforeverd.plugins.treesitter') end
    }

    use { 'nvim-treesitter/playground', requires = 'nvim-treesitter/nvim-treesitter' }

    use { 'p00f/nvim-ts-rainbow', requires = 'nvim-treesitter/nvim-treesitter' }

    use {
      'nvim-treesitter/nvim-treesitter-textobjects',
      requires = 'nvim-treesitter/nvim-treesitter'
    }

    use { 'nvim-treesitter/nvim-treesitter-refactor', requires = 'nvim-treesitter/nvim-treesitter' }

    use {
      'nvim-treesitter/nvim-tree-docs',
      requires = { { 'nvim-treesitter/nvim-treesitter' }, { 'Olical/aniseed' } }
    }

    use { 'Olical/conjure', ft = { 'clojure', 'fennel', 'janet', 'racket', 'scheme' } }

    use {
      'lukas-reineke/indent-blankline.nvim',
      config = function() require('aceforeverd.plugins.indent') end
    }

    use { 'hkupty/iron.nvim' }

    use { 'sakhnik/nvim-gdb' }

    use { 'rafcamlet/nvim-luapad', ft = { 'lua' } }

    use { 'folke/lua-dev.nvim', ft = { 'lua' } }

    -- use "b0o/schemastore.nvim"

    -- automatically create Lsp diagnostic highlight group is the colorshceme not defined it
    use { 'folke/lsp-colors.nvim', config = function() require('lsp-colors').setup {} end }

    use {
      'nvim-telescope/telescope.nvim',
      config = function() require('aceforeverd.plugins.telescope') end,
      requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use { 'nvim-telescope/telescope-packer.nvim', requires = { 'nvim-telescope/telescope.nvim' } }

    use { 'nvim-telescope/telescope-project.nvim', requires = { 'nvim-telescope/telescope.nvim' } }

    use {
      "nvim-telescope/telescope-frecency.nvim",
      requires = {
        'nvim-telescope/telescope.nvim',
        "tami5/sqlite.lua",
        'kyazdani42/nvim-web-devicons'
      }
    }

    use { 'xiyaowong/telescope-emoji.nvim', requires = { 'nvim-telescope/telescope.nvim' } }

    use {
      'ahmedkhalf/project.nvim',
      config = function() require("project_nvim").setup { manual_mode = false } end
    }

    use { 'jamestthompson3/nvim-remote-containers' }

    use { 'chipsenkbeil/distant.nvim', cmd = 'Distant*' }

    use {
      'sudormrfbin/cheatsheet.nvim',
      config = function()
        require("cheatsheet").setup({
          bundled_cheatsheets = true,
          bundled_plugin_cheatsheets = true,
          include_only_installed_plugins = true
        })
      end,
      requires = {
        { 'nvim-telescope/telescope.nvim' },
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' }
      }
    }

    use { 'cljoly/telescope-repo.nvim', requires = { 'nvim-telescope/telescope.nvim' } }

    use {
      'fannheyward/telescope-coc.nvim',
      cond = function() return vim.fn.has('nvim-0.6.0') == 0 end
    }

    use {
      "AckslD/nvim-neoclip.lua",
      requires = { 'tami5/sqlite.lua', module = 'sqlite' },
      config = function()
        require('neoclip').setup {
          enable_persistant_history = true,
          db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3"
        }
      end
    }

    use {
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function() require('aceforeverd.plugins.nvim-tree') end
    }

    use { 'phaazon/hop.nvim' }

    use { 'rafamadriz/friendly-snippets' }

    use { 'marko-cerovac/material.nvim' }

    use { 'projekt0n/github-nvim-theme' }

    use { 'Pocco81/Catppuccino.nvim' }

    use { 'monsonjeremy/onedark.nvim' }

    use {
      'vuki656/package-info.nvim',
      requires = { "MunifTanjim/nui.nvim" },
      config = function()
        require('package-info').setup {
          colors = {
            up_to_date = "#3C4048", -- Text color for up to date package virtual text
            outdated = "#d19a66" -- Text color for outdated package virtual text
          },
          icons = {
            enable = true -- Whether to display icons
          },
          autostart = false
        }
      end
    }

    use { 'mfussenegger/nvim-dap' }

    use { 'Pocco81/DAPInstall.nvim' }

    use { 'kevinhwang91/nvim-bqf' }

    use {
      'winston0410/range-highlight.nvim',
      requires = { 'winston0410/cmd-parser.nvim' },
      config = function() require'range-highlight'.setup {} end
    }

    use {
      'TimUntersberger/neogit',
      config = function() require('neogit').setup {} end,
      cmd = 'Neogit'
    }

    use { 'sindrets/diffview.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

    use { 'tversteeg/registers.nvim' }

    use { "npxbr/glow.nvim", ft = { 'markdown' } }

    use {
      'pwntester/octo.nvim',
      requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
      config = function() require"octo".setup() end,
      cmd = 'Octo*'
    }

    use { 'Pocco81/HighStr.nvim' }

    use {
      "akinsho/nvim-toggleterm.lua",
      config = function() require("aceforeverd.plugins.toggleterm") end
    }

    use {
      "SmiteshP/nvim-gps",
      config = function()
        require("nvim-gps").setup({
          icons = {
            ["class-name"] = ' ', -- Classes and class-like objects
            ["function-name"] = ' ', -- Functions
            ["method-name"] = ' ', -- Methods (functions inside class-like objects)
            ["container-name"] = ' ', -- Containers (example: lua tables)
            ["tag-name"] = '炙' -- Tags (example: html tags)
          },
          separator = ' > '
        })
      end,
      requires = "nvim-treesitter/nvim-treesitter"
    }

    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {
          plugins = { registers = false }
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    use {
      'kevinhwang91/nvim-hlslens',
      config = function()
        vim.api.nvim_set_keymap('n', '*', "*<Cmd>lua require('hlslens').start()<CR>",
                                { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '#', "#<Cmd>lua require('hlslens').start()<CR>",
                                { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', 'g*', "g*<Cmd>lua require('hlslens').start()<CR>",
                                { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', 'g#', "g#<Cmd>lua require('hlslens').start()<CR>",
                                { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>l', '<Cmd>noh<CR>', { silent = true, noremap = true })
      end
    }

    use {
      'JoosepAlviste/nvim-ts-context-commentstring',
      requires = { 'nvim-treesitter/nvim-treesitter' }
    }

    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    use { 'michaelb/sniprun', run = 'bash ./install.sh' }

    use { 'rcarriga/nvim-notify', opt = true }

    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup { hl = 'SpellBad', captures = { 'comment' } }
      end
    }

    use {
      'lewis6991/gitsigns.nvim',
      cond = function() return vim.fn.has('nvim-0.5.0') == 1 end,
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() require('aceforeverd.plugins.gitsigns') end
    }

    use {
      'famiu/feline.nvim',
      cond = function() return vim.fn.has('nvim-0.5.0') == 1 end,
      requires = { 'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
      config = function() require('aceforeverd.plugins.feline') end
    }

    use {
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      cond = function() return vim.fn.has('nvim-0.5.0') == 1 end,
      config = function() require('aceforeverd.plugins.bufferline') end
    }

    use { 'famiu/bufdelete.nvim' }

  end
})

