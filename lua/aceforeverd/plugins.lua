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
    autocmd FileType packer nnoremap <buffer> <esc> :<cmd>lua require('packer.display').quit()<cr>
  augroup end
]])
-- autocmd BufWritePost plugins.lua source <afile> | PackerCompile

local packer = require('packer')

local util = require('packer.util')
packer.init({
  package_root = util.join_paths(config_path, 'bundle/pack'),
  compile_path = util.join_paths(config_path, 'plugin', 'packer_compiled.vim'),
  plugin_package = 'packer',
  max_jobs = 12,
  git = { clone_timeout = 30 },
  display = { open_fn = require('packer.util').float, keybindings = { quit = 'q' } },
  profile = { enable = true, threshold = 1 },
})

return packer.startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })

    use({
      'neovim/nvim-lspconfig',
      requires = {
        -- neovim builtin lsp status line component
        'nvim-lua/lsp-status.nvim',
        -- LSP signature hint as you type
        'ray-x/lsp_signature.nvim',
        -- fzf handlers
        'gfanto/fzf-lsp.nvim',
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
      },
      config = function()
        require('aceforeverd.lsp.installer').setup()
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
        'quangnguyen30192/cmp-nvim-ultisnips',
        'petertriho/cmp-git',
        'hrsh7th/cmp-vsnip',
        'f3fora/cmp-spell',

        'onsails/lspkind-nvim',
      },
      config = function()
        require('aceforeverd.plugins.nvim-cmp').setup()
      end,
    })

    use({
      'L3MON4D3/LuaSnip',
      requires = { 'saadparwaiz1/cmp_luasnip' },
      config = function()
        require('aceforeverd.plugins.snip').luasnip_setup()
      end,
    })

    use({
      'SirVer/ultisnips',
      cond = function()
        return vim.g.with_ultisnips == 1 and vim.fn.has('python3')
      end,
      setup = function()
        require('aceforeverd.plugins.snip').ultisnip_setup_pre()
      end,
    })

    use({
      'hrsh7th/vim-vsnip',
      requires = {
        {
          'hrsh7th/vim-vsnip-integ',
          cond = function()
            return vim.g.with_vsnip == 1
          end,
        },
      },
      cond = function()
        return vim.g.with_vsnip == 1
      end,
      config = function()
        require('aceforeverd.plugins.snip').vsnip_setup()
      end,
    })

    use({
      'onsails/lspkind-nvim',
      config = function()
        require('lspkind').init({ with_text = true })
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

    use({ 'weilbith/nvim-code-action-menu', cmd = { 'CodeActionMenu' } })

    use({
      'simrat39/rust-tools.nvim',
      requires = { 'williamboman/nvim-lsp-installer' },
      event = { 'BufRead Cargo.toml', 'FileType rust' },
      config = function()
        require('aceforeverd.plugins.rust-tools').setup()
      end,
    })

    use({
      'mfussenegger/nvim-jdtls',
      ft = { 'java' },
      requires = { 'williamboman/nvim-lsp-installer' },
      config = function()
        require('aceforeverd.plugins.jdtls').setup()
      end,
    })

    use({
      'scalameta/nvim-metals',
      requires = { 'nvim-lua/plenary.nvim', 'williamboman/nvim-lsp-installer' },
      ft = { 'scala', 'sbt' },
      config = function()
        require('aceforeverd.plugins.metals').setup()
      end,
    })

    use({
      'ray-x/go.nvim',
      requires = { 'neovim/nvim-lspconfig' },
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
        require('aceforeverd.plugins.illuminate').setup()
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
      -- requires cargo
      'liuchengxu/vim-clap',
      run = ':Clap install-binary',
      setup = function()
        require('aceforeverd.plugins.clap').before_load()
      end,
      config = function()
        require('aceforeverd.plugins.clap').setup()
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

    use({ 'pwntester/codeql.nvim' })

    use({
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/playground',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
        'RRethy/nvim-treesitter-textsubjects',
        'p00f/nvim-ts-rainbow',
        { 'nvim-treesitter/nvim-tree-docs', requires = { 'Olical/aniseed' } },
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
        require('aceforeverd.plugins.indent').setup()
      end,
    })

    use({
      'hkupty/iron.nvim',
      setup = function()
        vim.g.iron_map_defaults = 0
        vim.g.iron_map_extended = 0
      end,
    })

    use({ 'sakhnik/nvim-gdb' })

    -- automatically create Lsp diagnostic highlight group is the colorshceme not defined it
    use({
      'folke/lsp-colors.nvim',
      config = function()
        require('lsp-colors').setup({})
      end,
    })

    use({
      'creativenull/diagnosticls-configs-nvim',
      opt = true,
    })

    use({
      'nvim-telescope/telescope.nvim',
      config = function()
        require('aceforeverd.plugins.telescope').setup()
      end,
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-packer.nvim',
        'nvim-telescope/telescope-project.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'cljoly/telescope-repo.nvim',
        'fhill2/telescope-ultisnips.nvim',
        'jvgrootveld/telescope-zoxide',
      },
    })

    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

    use({
      'nvim-telescope/telescope-frecency.nvim',
      requires = {
        'nvim-telescope/telescope.nvim',
        -- requires sqlite3 installed
        'tami5/sqlite.lua',
        'kyazdani42/nvim-web-devicons',
      },
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

    use({ 'jamestthompson3/nvim-remote-containers' })

    use({ 'chipsenkbeil/distant.nvim', cmd = 'Distant*' })

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
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
      cmd = { 'NvimTreeToggle', 'NvimTreeClipboard', 'NvimTreeFindFileToggle' },
      keys = { '<space>e' },
      config = function()
        require('aceforeverd.plugins.nvim-tree').setup()
      end,
    })

    use({
      'phaazon/hop.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').hop()
      end,
    })

    use({ 'rafamadriz/friendly-snippets' })

    use({ 'marko-cerovac/material.nvim' })

    use({ 'projekt0n/github-nvim-theme' })

    use({ 'monsonjeremy/onedark.nvim' })

    use({ 'mfussenegger/nvim-dap' })

    use({ 'Pocco81/DAPInstall.nvim' })

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

    use({ 'sindrets/diffview.nvim', requires = { 'kyazdani42/nvim-web-devicons' } })

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
        require('aceforeverd.plugins.octo').setup()
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
        require('aceforeverd.plugins.gps').setup()
      end,
      requires = 'nvim-treesitter/nvim-treesitter',
    })

    use({
      'romgrk/nvim-treesitter-context',
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
      'JoosepAlviste/nvim-ts-context-commentstring',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('aceforeverd.plugins.treesitter').comment_string()
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
      cmd = { 'SnipRun', 'SnipClose', 'SnipInfo', 'SnipReset', 'SnipTerminate', 'SnipReplMemoryClean' },
    })

    use({ 'rcarriga/nvim-notify', opt = true })

    use({
      'lewis6991/spellsitter.nvim',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      opt = true,
      config = function()
        require('spellsitter').setup({
          -- enable = { 'cpp', 'lua', 'python', 'java', 'c', 'vim', 'sh' },
          hl = 'SpellBad',
        })
      end,
    })

    use({
      'nvim-orgmode/orgmode',
      requires = { 'nvim-orgmode/orgmode' },
      -- ft = { 'org' },
      opt = true,
      config = function()
        require('aceforeverd.plugins.orgmode').setup()
      end,
    })

    use({
      'lewis6991/gitsigns.nvim',
      cond = function()
        return vim.fn.has('nvim-0.5.0') == 1
      end,
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('aceforeverd.plugins.gitsigns').setup()
      end,
    })

    use({
      'ruifm/gitlinker.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitlinker').setup({})
      end,
    })

    use({
      'anuvyklack/pretty-fold.nvim',
      config = function()
        require('aceforeverd.plugins.enhance').pretty_fold()
      end,
    })

    use({
      'feline-nvim/feline.nvim',
      cond = function()
        return vim.g.my_statusline == 'feline'
      end,
      requires = { 'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
      config = function()
        require('aceforeverd.plugins.statusline.feline')
      end,
    })

    use({
      'nvim-lualine/lualine.nvim',
      cond = function()
        return vim.g.my_statusline == 'lualine'
      end,
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('aceforeverd.plugins.statusline.lualine').setup()
      end,
    })

    use({
      'itchyny/lightline.vim',
      cond = function()
        return vim.g.my_statusline == 'lightline'
      end,
      setup = function()
        require('aceforeverd.plugins.statusline.lightline').setup()
      end,
    })

    use({
      'noib3/cokeline.nvim',
      cond = function()
        return vim.g.my_tabline == 'cokeline'
      end,
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('aceforeverd.plugins.tabline.cokeline').setup()
      end,
    })

    use({
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      cond = function()
        return vim.g.my_tabline == 'bufferline'
      end,
      config = function()
        require('aceforeverd.plugins.tabline.bufferline')
      end,
    })

    use({
      'famiu/bufdelete.nvim',
      config = function()
        vim.api.nvim_set_keymap('n', '<leader>bd', '<cmd>Bdelete<cr>', { noremap = true, silent = true })
      end,
    })

    use({
      'simrat39/symbols-outline.nvim',
      setup = function()
        vim.g.symbols_outline = { highlight_hovered_item = true }
      end,
      cmd = { 'SymbolsOutline' },
    })

    use({
      'ibhagwan/fzf-lua',
      requires = { 'vijaymarupudi/nvim-fzf', 'kyazdani42/nvim-web-devicons' },
      cmd = { 'FzfLua' },
      config = function()
        require('fzf-lua').setup({ winopts = { width = 0.9 } })
      end,
    })

    use({
      'numToStr/Comment.nvim',
      requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
      config = function()
        require('aceforeverd.plugins.comment')
      end,
    })

    use({
      'windwp/nvim-autopairs',
      cond = function()
        return vim.g.my_autopair == 'nvim-autopairs'
      end,
      config = function()
        require('aceforeverd.plugins.autopairs').setup()
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
      opt = true,
      config = function()
        require('marks').setup({})
      end,
    })

    use({
      's1n7ax/nvim-comment-frame',
      requires = {
        'nvim-treesitter/nvim-treesitter',
      },
      keys = { '<leader>cc', '<leader>cm' },
      config = function()
        require('nvim-comment-frame').setup({
          -- single line comment
          keymap = '<leader>cc',
          -- multiple line comment
          multiline_keymap = '<leader>cm',
        })
      end,
    })

    use({
      'wfxr/minimap.vim',
      cond = function()
        return vim.fn.executable('code-minimap') == 1
      end,
      cmd = { 'MinimapToggle' },
    })

    use({
      'nvim-pack/nvim-spectre',
      config = function()
        require('aceforeverd.plugins.enhance').spectre()
      end,
    })
  end,
})
