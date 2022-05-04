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

local packer_install_path = config_path .. '/bundle/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path })
  vim.api.nvim_notify('automatically installed packer.nvim into ' .. packer_install_path, 2, {})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd User PackerComplete lua vim.api.nvim_notify('Packer Done', 2, {})
    autocmd User PackerCompileDone lua vim.api.nvim_notify('PackerCompile Done', 2, {})
  augroup end
]])
-- autocmd BufWritePost plugins.lua source <afile> | PackerCompile

local packer = require('packer')

local util = require('packer.util')
packer.init({
  package_root = util.join_paths(config_path, 'bundle/pack'),
  compile_path = util.join_paths(config_path, 'plugin', 'packer_compiled.lua'),
  plugin_package = 'packer',
  max_jobs = 8,
  git = { clone_timeout = 30 },
  -- display = { open_fn = require('packer.util').float, keybindings = { quit = 'q' } },
  profile = { enable = true, threshold = 1 },
})

return packer.startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })

    use({ 'lewis6991/impatient.nvim' })

    use({
      'nvim-lua/lsp-status.nvim',
      config = function()
        require('aceforeverd.lsp').lsp_status()
      end,
    })

    use({
      'neovim/nvim-lspconfig',
      requires = {
        -- LSP signature hint as you type
        'ray-x/lsp_signature.nvim',
        'p00f/clangd_extensions.nvim',
      },
      config = function()
        require('aceforeverd.lsp').setup()
      end,
    })

    use({
      'williamboman/nvim-lsp-installer',
      requires = {
        'neovim/nvim-lspconfig',
        'folke/lua-dev.nvim',
        'b0o/schemastore.nvim',
        'nanotee/sqls.nvim',
        'simrat39/rust-tools.nvim',
      },
      config = function()
        require('aceforeverd.lsp.installer').setup()
      end,
    })

    use({
      'onsails/lspkind.nvim',
      config = function()
        require('aceforeverd.lsp').lspkind()
      end,
    })

    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-calc',
        'uga-rosa/cmp-dictionary',
        'ray-x/cmp-treesitter',
        'andersevenrud/cmp-tmux',
        'petertriho/cmp-git',
        'f3fora/cmp-spell',

        'onsails/lspkind-nvim',
      },
      config = function()
        require('aceforeverd.plugins.nvim-cmp').setup()
      end,
    })

    use({
      'j-hui/fidget.nvim',
    })

    use({
      'L3MON4D3/LuaSnip',
      requires = {
        'rafamadriz/friendly-snippets',
        'saadparwaiz1/cmp_luasnip',
      },
      config = function()
        require('aceforeverd.plugins.snip').luasnip_setup()
      end,
    })

    use({
      'kosayoda/nvim-lightbulb',
      config = function()
        require('aceforeverd.plugins.enhance').light_bulb()
      end,
      cond = function()
        return vim.g.my_cmp_source == 'nvim_lsp'
      end,
    })

    use({
      'weilbith/nvim-code-action-menu',
    })

    use({
      'mfussenegger/nvim-jdtls',
      ft = { 'java' },
      requires = { 'williamboman/nvim-lsp-installer' },
      config = function()
        require('aceforeverd.config.ft_plugins').jdtls()
      end,
    })

    use({
      'scalameta/nvim-metals',
      requires = { 'nvim-lua/plenary.nvim', 'williamboman/nvim-lsp-installer' },
      ft = { 'scala', 'sbt' },
      config = function()
        require('aceforeverd.config.ft_plugins').metals()
      end,
    })

    use({
      'ray-x/go.nvim',
      requires = {
        'neovim/nvim-lspconfig',
        { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
      },
      ft = { 'go', 'gomod', 'gohtmltmpl', 'gotexttmpl' },
      config = function()
        require('aceforeverd.lsp').go()
      end,
    })

    use({
      'RRethy/vim-illuminate',
      cond = function()
        return vim.g.my_cmp_source == 'nvim_lsp'
      end,
      config = function()
        require('aceforeverd.config.tools').illuminate()
      end,
    })

    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'neovim/nvim-lspconfig' },
      cond = function()
        return vim.g.my_cmp_source == 'nvim_lsp'
      end,
      config = function()
        require('aceforeverd.plugins.null-ls').setup()
      end,
    })

    use({
      'norcalli/nvim-colorizer.lua',
      cond = function()
        return vim.g.my_cmp_source == 'nvim_lsp'
      end,
      config = function()
        require('colorizer').setup()
      end,
    })

    use({ 'nvim-lua/plenary.nvim' })

    use({
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/playground',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
        'RRethy/nvim-treesitter-textsubjects',
        'p00f/nvim-ts-rainbow',
        { 'nvim-treesitter/nvim-tree-docs', requires = { 'Olical/aniseed' } },
        'RRethy/nvim-treesitter-endwise',
        'JoosepAlviste/nvim-ts-context-commentstring',
        'windwp/nvim-ts-autotag',
      },
      run = ':TSUpdate',
      config = function()
        require('aceforeverd.plugins.treesitter').setup()
      end,
    })

    use({
      'mizlan/iswap.nvim',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('aceforeverd.plugins.treesitter').iswap()
      end,
    })

    use({ 'Olical/conjure', ft = { 'clojure', 'fennel', 'janet', 'racket', 'scheme' } })

    use({
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').indent_blankline()
      end,
    })

    use({
      'hkupty/iron.nvim',
      setup = function()
        vim.g.iron_map_defaults = 0
        vim.g.iron_map_extended = 0
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      config = function()
        require('aceforeverd.finder').telescope()
      end,
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },

        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-packer.nvim',
        'nvim-telescope/telescope-project.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-github.nvim',
        'cljoly/telescope-repo.nvim',
        'jvgrootveld/telescope-zoxide',

        'nvim-telescope/telescope-frecency.nvim',
        'LinArcX/telescope-env.nvim',
        'tami5/sqlite.lua',
        'kyazdani42/nvim-web-devicons',
      },
    })

    use({
      'pwntester/codeql.nvim',
      ft = { 'ql' },
      requires = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('codeql').setup({})
      end,
    })

    use({
      'ahmedkhalf/project.nvim',
      config = function()
        require('project_nvim').setup({
          manual_mode = false,
          silent_chdir = false,
        })
      end,
    })

    use({
      'sudormrfbin/cheatsheet.nvim',
      cmd = { 'Cheatsheet', 'CheatsheetEdit' },
      config = function()
        require('cheatsheet').setup({
          bundled_cheatsheets = true,
          bundled_plugin_cheatsheets = true,
          include_only_installed_plugins = true,
        })
      end,
      requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    })

    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
      setup = function()
        vim.g.neo_tree_remove_legacy_commands = 1
      end,
      config = function()
        require('aceforeverd.plugins.tree').neo_tree()
      end,
      cmd = { 'Neotree' },
      keys = { '<space>e' },
    })

    use({
      'phaazon/hop.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').hop()
      end,
    })

    use({ 'marko-cerovac/material.nvim' })

    use({ 'projekt0n/github-nvim-theme' })

    use({ 'monsonjeremy/onedark.nvim' })

    use({
      'mfussenegger/nvim-dap',
      requires = {
        'rcarriga/nvim-dap-ui',
      },
    })

    use({ 'kevinhwang91/nvim-bqf' })

    use({
      'nacro90/numb.nvim',
      config = function()
        require('numb').setup({ show_numbers = true, show_cursorline = true, number_only = false })
      end,
    })

    use({
      'TimUntersberger/neogit',
      config = function()
        require('neogit').setup({})
      end,
      cmd = 'Neogit',
    })

    use({
      'sindrets/diffview.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('aceforeverd.plugins.git').diffview()
      end,
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' }
    })

    use({
      'tversteeg/registers.nvim',
      cond = function()
        return vim.g.with_registers == 1
      end,
      setup = function()
        require('aceforeverd.plugins.enhance').registers_pre()
      end,
    })

    use({ 'npxbr/glow.nvim', ft = { 'markdown' } })

    use({
      'pwntester/octo.nvim',
      requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('aceforeverd.plugins.git').octo()
      end,
      cmd = { 'Octo', 'OctoAddReviewComment', 'OctoAddReviewSuggestion' },
    })

    use({ 'Pocco81/HighStr.nvim' })

    use({
      'akinsho/nvim-toggleterm.lua',
      config = function()
        require('aceforeverd.plugins.enhance').toggle_term()
      end,
    })

    use({
      'SmiteshP/nvim-gps',
      config = function()
        require('aceforeverd.config').gps()
      end,
      requires = 'nvim-treesitter/nvim-treesitter',
    })

    use({
      'lewis6991/nvim-treesitter-context',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('aceforeverd.plugins.treesitter').ts_context()
      end,
    })

    use({
      'mfussenegger/nvim-treehopper',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('aceforeverd.plugins.treesitter').tree_hopper()
      end,
    })

    use({
      'folke/which-key.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').which_key()
      end,
    })

    use({
      'kevinhwang91/nvim-hlslens',
      cond = function()
        return vim.g.with_hlslens == 1
      end,
      config = function()
        require('aceforeverd.plugins.enhance').hlslens()
      end,
    })

    use({
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('todo-comments').setup({})
      end,
    })

    use({
      'michaelb/sniprun',
      run = 'bash install.sh',
    })

    use({
      'rcarriga/nvim-notify',
      opt = true,
      config = function()
        require('notify').setup()
      end,
    })

    use({
      'lewis6991/spellsitter.nvim',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      opt = true,
      config = function()
        require('spellsitter').setup({
          -- enable = { 'cpp', 'lua', 'python', 'java', 'c', 'vim', 'sh' },
        })
      end,
    })

    use({
      'nvim-neorg/neorg',
      requires = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
      setup = vim.cmd('autocmd BufRead,BufNewFile *.norg setlocal filetype=norg'),
      after = { 'nvim-treesitter' }, -- you may also specify telescope
      ft = 'norg',
      config = function()
        require('aceforeverd.config.ft_plugins').norg()
      end,
    })

    use({
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('aceforeverd.plugins.git').gitsigns()
      end,
    })

    use({
      'akinsho/git-conflict.nvim',
      config = function()
        require('aceforeverd.plugins.git').git_conflict()
      end,
    })

    use({
      'ruifm/gitlinker.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('aceforeverd.plugins.git').gitlinker()
      end,
    })

    use({
      'anuvyklack/pretty-fold.nvim',
      requires = 'anuvyklack/nvim-keymap-amend',
      config = function()
        require('aceforeverd.plugins.enhance').pretty_fold()
      end,
      opt = true,
    })

    use({
      'feline-nvim/feline.nvim',
      cond = function()
        return vim.g.my_statusline == 'feline'
      end,
      requires = { 'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
      config = function()
        require('aceforeverd.statusline.feline')
      end,
    })

    use({
      'nvim-lualine/lualine.nvim',
      cond = function()
        return vim.g.my_statusline == 'lualine'
      end,
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('aceforeverd.statusline.lualine').setup()
      end,
    })

    use({
      'noib3/cokeline.nvim',
      cond = function()
        return vim.g.my_tabline == 'cokeline'
      end,
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('aceforeverd.tabline').cokeline()
      end,
    })

    use({
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      cond = function()
        return vim.g.my_tabline == 'bufferline'
      end,
      config = function()
        require('aceforeverd.tabline').bufferline()
      end,
    })

    use({
      'famiu/bufdelete.nvim',
      config = function()
        vim.api.nvim_set_keymap('n', '<leader>bd', '<cmd>Bdelete<cr>', { noremap = true, silent = true })
      end,
    })

    use({
      'stevearc/aerial.nvim',
      config = function()
        require('aerial').setup()
      end,
    })

    use({
      'ibhagwan/fzf-lua',
      requires = { 'vijaymarupudi/nvim-fzf', 'kyazdani42/nvim-web-devicons' },
      cmd = { 'FzfLua' },
      config = function()
        require('aceforeverd.finder').fzflua()
      end,
    })

    use({
      'numToStr/Comment.nvim',
      requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
      config = function()
        require('aceforeverd.plugins.comment').setup()
      end,
    })

    use({
      'windwp/nvim-autopairs',
      cond = function()
        return vim.g.my_autopair == 'nvim-autopairs'
      end,
      config = function()
        require('aceforeverd.plugins.enhance').autopairs()
      end,
    })

    use({
      'luukvbaal/nnn.nvim',
      cmd = { 'NnnExplorer', 'NnnPicker' },
      config = function()
        require('nnn').setup()
      end,
    })

    use({
      'vuki656/package-info.nvim',
      requires = { 'MunifTanjim/nui.nvim' },
      event = { 'BufRead package.json' },
      config = function()
        require('package-info').setup({
          icons = {
            enable = true, -- Whether to display icons
          },
          autostart = true,
        })
      end,
    })

    use({
      'Saecki/crates.nvim',
      event = { 'BufRead Cargo.toml' },
      requires = { { 'nvim-lua/plenary.nvim' } },
      config = function()
        require('crates').setup()
      end,
    })

    use({
      'chentau/marks.nvim',
      config = function()
        require('marks').setup({})
      end,
    })

    use({
      'wfxr/minimap.vim',
      cmd = { 'MinimapToggle' },
    })

    use({
      'nvim-pack/nvim-spectre',
      config = function()
        require('aceforeverd.plugins.enhance').spectre()
      end,
      cmd = { 'Spectre', 'SpectreCFile' },
    })

    use({ 'gennaro-tedesco/nvim-jqx' })

    use({ 'milisims/nvim-luaref' })

    use({
      'google/vim-codefmt',
      requires = {
        'google/vim-maktaba',
        'google/vim-glaive',
      },
      opt = true,
      config = function()
        vim.api.nvim_call_function('aceforeverd#settings#glaive', {})
      end,
    })

    use({
      'google/vim-coverage',
      requires = {
        'google/vim-maktaba',
        'google/vim-glaive',
      },
      opt = true,
    })

    -- ui
    use({
      'stevearc/dressing.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').dressing()
      end,
    })

    use({
      'mrjones2014/legendary.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').legendary()
      end,
      cmd = { 'Legendary' }
    })

    use({
      'bennypowers/nvim-regexplainer',
      ft = { 'html', 'js', 'ts' },
      config = function()
        require('regexplainer').setup({
          mappings = {
            toggle = '<leader>re',
          },
        })
      end,
      requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
      },
    })

    use({
      'danymat/neogen',
      config = function()
        require('aceforeverd.plugins.enhance').neogen()
      end,
      requires = {
        'nvim-treesitter/nvim-treesitter',
        'L3MON4D3/LuaSnip',
      },
      cmd = 'Neogen',
    })

    use({
      'p00f/godbolt.nvim',
      config = function()
        require('godbolt').setup({})
      end,
      cmd = { 'GodboltCompiler', 'Godbolt' },
    })
    use({
      'mrjones2014/dash.nvim',
      run = 'make install',
      cond = function()
        return vim.fn.has('mac') == 1
      end,
      config = function()
        require('aceforeverd.finder').dash()
      end,
    })

    use({
      'rcarriga/vim-ultest',
    })

    use({
      'folke/zen-mode.nvim',
      config = function()
        require('zen-mode').setup({})
      end,
      cmd = { 'ZenMode' },
    })

    use({
      'rlane/pounce.nvim'
    })
  end,
})
