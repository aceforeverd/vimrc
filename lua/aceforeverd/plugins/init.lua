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

local M = {}

function M.setup()
  M.lazy()
  -- lazy.nvim disables loadplugins by default
  vim.go.loadplugins = true
end

function M.lazy()
  -- bootstrap plugin manager
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.api.nvim_notify('installing lazy.nvim to ' .. lazypath .. ' ...', vim.log.levels.INFO, {})
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- setup
  require('lazy').setup(M.plugin_list, {
    install = {
      missing = false,
    },
    concurrency = 8,
    performance = {
      -- no reset, or other plugin manager won't work
      reset_packpath = false,
      rtp = {
        reset = false,
      },
    },
  })
end

M.plugin_list = {
  { 'folke/lazy.nvim' },

  { 'nvim-lua/plenary.nvim' },

  -- installer
  {
    'williamboman/mason.nvim',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    lazy = true,
  },

  {
    'SmiteshP/nvim-navic',
    config = function()
      require('nvim-navic').setup({
        click = true,
        lsp = { auto_attach = true },
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          if vim.api.nvim_buf_line_count(0) > 10000 then
            vim.b.navic_lazy_update_context = true
          end
        end,
      })
    end,
  },

  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
    },
    opts = { lsp = { auto_attach = true } },
  },

  {
    'nvim-lua/lsp-status.nvim',
    config = function()
      local lsp_status = require('lsp-status')
      local lsp_status_diagnostic_enable = vim.g.my_statusline == 'lightline'
      lsp_status.config({
        select_symbol = function(cursor_pos, symbol)
          if symbol.valueRange then
            local value_range = {
              ['start'] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
              ['end'] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) },
            }

            return require('lsp-status.util').in_range(cursor_pos, value_range)
          end
        end,
        current_function = true,
        show_filename = false,
        status_symbol = '🐶',
        diagnostics = true,
      })

      lsp_status.register_progress()
    end,
    lazy = true,
  },

  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end,
    lazy = true,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      -- LSP signature hint as you type
      'ray-x/lsp_signature.nvim',
      'p00f/clangd_extensions.nvim',
      -- lsp enhance
      'folke/neodev.nvim',
      'b0o/schemastore.nvim',
      'mfussenegger/nvim-jdtls',
      'scalameta/nvim-metals',
      'SmiteshP/nvim-navic',
      'SmiteshP/nvim-navbuddy',
      'MunifTanjim/nui.nvim',
      -- statusline
      'nvim-lua/lsp-status.nvim',
      'linrongbin16/lsp-progress.nvim',
    },
    config = function()
      require('aceforeverd.lsp').setup()
    end,
  },

  {
    'mrcjkb/haskell-tools.nvim',
    config = function()
      require('aceforeverd.lsp').hls()
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    ft = { 'haskell', 'cabal' },
  },

  {
    'onsails/lspkind.nvim',
    config = function()
      require('lspkind').init({
        mode = 'symbol_text',
      })
    end,
    lazy = true,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-emoji',
      'uga-rosa/cmp-dictionary',
      'ray-x/cmp-treesitter',
      'andersevenrud/cmp-tmux',
      'petertriho/cmp-git',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
    },
    event = 'InsertEnter',
    config = function()
      require('aceforeverd.plugins.nvim-cmp').setup()
    end,
  },

  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup({
        lightbulb = {
          virtual_text = false,
        },
        symbol_in_winbar = {
          enable = false,
        },
      })
    end,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  },

  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('aceforeverd.plugins.snip').luasnip_setup()
    end,
    build = 'make install_jsregexp',
  },

  {
    'simrat39/rust-tools.nvim',
    ft = { 'rust' },
    config = function()
      require('aceforeverd.lsp').rust_analyzer()
    end,
  },

  { 'ray-x/guihua.lua', build = 'cd lua/fzy && make', lazy = true },

  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('aceforeverd.lsp').go()
    end,
    ft = { 'go', 'gomod' },
  },

  {
    'RRethy/vim-illuminate',
    dependencies = { 'nvim-lspconfig' },
    config = function()
      require('illuminate').configure({
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        delay = vim.go.updatetime,
      })

      vim.keymap.set('n', '<a-i>', function()
        require('illuminate').toggle_pause()
      end, { noremap = true })
    end,
    event = 'VeryLazy',
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('aceforeverd.plugins.null-ls').setup()
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({})
    end,
    ft = { 'css', 'html' },
  },

  {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
      'HiPhish/nvim-ts-rainbow2',
      'RRethy/nvim-treesitter-endwise',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    config = function()
      require('aceforeverd.config.treesitter').setup()
    end,
  },

  {
    'mizlan/iswap.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('iswap').setup({
        autoswap = true, -- auto swap if there is only two params
      })
    end,
    cmd = { 'ISwap', 'ISwapWith', 'ISwapNode', 'ISwapNodeWith' },
  },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    keys = { 'gS', 'gJ' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })

      vim.g.splitjoin_split_mapping = ''
      vim.g.splitjoin_join_mapping = ''
      -- thanks https://github.com/Wansmer/treesj/discussions/19
      local langs = require('treesj.langs')['presets']

      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = '*',
        callback = function()
          local opts = { buffer = true }
          if langs[vim.bo.filetype] then
            vim.keymap.set('n', 'gS', '<Cmd>TSJSplit<CR>', opts)
            vim.keymap.set('n', 'gJ', '<Cmd>TSJJoin<CR>', opts)
          else
            vim.keymap.set('n', 'gS', '<Cmd>SplitjoinSplit<CR>', opts)
            vim.keymap.set('n', 'gJ', '<Cmd>SplitjoinJoin<CR>', opts)
          end
        end,
      })
    end,
  },

  {
    -- generic ts node actions: config later
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    opts = {},
    lazy = true,
  },

  { 'Olical/conjure', ft = { 'clojure', 'fennel', 'janet', 'racket', 'scheme' } },

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('aceforeverd.plugins.enhance').indent_blankline()
    end,
  },

  {
    'Vigemus/iron.nvim',
    cmd = { 'IronRepl', 'IronReplHere' },
    config = function()
      require('iron.core').setup({
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {},
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').bottom(40),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {},
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })
    end,
  },

  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', lazy = true },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('aceforeverd.finder').telescope()
    end,
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',

      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-github.nvim',
      'cljoly/telescope-repo.nvim',
      'jvgrootveld/telescope-zoxide',

      'nvim-telescope/telescope-frecency.nvim',
      'LinArcX/telescope-env.nvim',
      'tami5/sqlite.lua',
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        manual_mode = false,
        silent_chdir = true,
        detection_methods = { 'pattern', 'lsp' },
      })
    end,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    config = function()
      require('neo-tree').setup({
        filesystem = {
          hijack_netrw_behavior = 'disabled',
          window = {
            mappings = {
              ['o'] = 'open',
              ['g/'] = 'filter_as_you_type',
              ['gf'] = 'filter_on_submit',
              ['g?'] = 'show_help',
              ['/'] = 'none',
              ['?'] = 'none',
              ['f'] = 'none',
            },
          },
        },
      })
    end,
    cmd = { 'Neotree' },
    keys = { { '<space>e', '<cmd>Neotree toggle reveal<cr>', desc = 'Neotree' } },
  },

  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = false,
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'Oil' },
    keys = { { '<space>o', '<cmd>Oil<cr>', desc = 'Oil' } },
  },

  { 'projekt0n/github-nvim-theme' },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
  },

  {
    'sakhnik/nvim-gdb',
    lazy = true,
  },

  { 'kevinhwang91/nvim-bqf', ft = { 'qf' } },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      require('aceforeverd.apperance').ufo()
    end,
  },

  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup({ show_numbers = true, show_cursorline = true, number_only = false })
    end,
  },

  {
    'TimUntersberger/neogit',
    config = function()
      require('neogit').setup({})
    end,
    cmd = 'Neogit',
  },

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('aceforeverd.integration.git').diffview()
    end,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  },

  {
    'gbprod/yanky.nvim',
    config = function()
      require('aceforeverd.plugins.enhance').yanky()
    end,
  },

  {
    'gbprod/substitute.nvim',
    config = function()
      require('aceforeverd.plugins.enhance').substitute()
    end,
  },

  {
    'npxbr/glow.nvim',
    ft = { 'markdown' },
    config = function()
      require('glow').setup({})
    end,
  },

  {
    'pwntester/octo.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('aceforeverd.integration.git').octo()
    end,
    cmd = { 'Octo', 'OctoAddReviewComment', 'OctoAddReviewSuggestion' },
  },

  {
    'akinsho/nvim-toggleterm.lua',
    config = function()
      require('aceforeverd.plugins.enhance').toggle_term()
    end,
  },

  {
    'mfussenegger/nvim-treehopper',
    keys = {
      { '<space>', [[:<C-U>lua require('tsht').nodes()<CR>]], mode = 'o', { silent = true } },
      {
        '<space>',
        [[:lua require('tsht').nodes()<cr>]],
        mode = 'x',
        { silent = true, noremap = true },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({ plugins = { registers = true } })
    end,
  },

  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup({
        highlight = {
          exclude = { 'qf', 'packer' },
        },
      })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('aceforeverd.integration.git').gitsigns()
    end,
  },

  {
    'ruifm/gitlinker.nvim',
    config = function()
      require('gitlinker').setup({
        opts = {
          remote = 'upstream',
        },
      })
    end,
    keys = {
      { '<leader>gy', mode = { 'n', 'v' }, desc = 'permalink to given range' },
      {
        '<leader>gY',
        function()
          require('gitlinker').get_repo_url()
        end,
        { silent = true },
        desc = 'Repo url',
      },
      {
        '<leader>gb',
        function()
          require('gitlinker').get_buf_range_url(
            'n',
            { action_callback = require('gitlinker.actions').open_in_browser }
          )
        end,
        mode = 'n',
        desc = 'Browse permalink of current line',
      },
      {
        '<leader>gb',
        function()
          require('gitlinker').get_buf_range_url(
            'v',
            { action_callback = require('gitlinker.actions').open_in_browser }
          )
        end,
        mode = 'v',
        desc = 'Browse permalink of range',
      },
      {
        '<leader>gB',
        function()
          require('gitlinker').get_repo_url({ action_callback = require('gitlinker.actions').open_in_browser })
        end,
        { silent = true },
        desc = 'Browse repo',
      },
    },
  },

  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete' },
    keys = {
      { '<leader>bd', '<cmd>Bdelete<cr>', { noremap = true, silent = true }, desc = 'delete buffer' },
    },
  },

  {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup({
        backends = { 'lsp', 'treesitter', 'markdown', 'man' },
      })
    end,
    keys = {
      { '<space>t', '<cmd>AerialToggle!<cr>', desc = 'Toggle the aerial window' },
    },
  },

  {
    'ibhagwan/fzf-lua',
    dependencies = { 'vijaymarupudi/nvim-fzf', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('aceforeverd.finder').fzflua()
    end,
  },

  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      vim.g.tcomment_maps = 0

      require('Comment').setup({
        mappings = {
          basic = true,
          extra = true,
          -- extended maps ? https://github.com/numToStr/Comment.nvim/wiki/Extended-Keybindings
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
    event = 'VeryLazy',
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('aceforeverd.plugins.enhance').autopairs()
    end,
  },

  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    event = { 'BufRead package.json' },
    config = function()
      require('package-info').setup({
        icons = {
          enable = true, -- Whether to display icons
        },
        autostart = true,
      })
    end,
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
    end,
  },

  {
    'gennaro-tedesco/nvim-jqx',
    ft = { 'json', 'yaml' },
  },

  { 'milisims/nvim-luaref' },

  -- UI
  {
    'freddiehaddad/feline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = function()
      return vim.g.my_statusline == 'feline'
    end,
    config = function()
      require('aceforeverd.apperance').feline()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = function()
      return vim.g.my_statusline == 'lualine'
    end,
    config = function()
      require('aceforeverd.apperance').lualine()
    end,
  },
  {
    'akinsho/nvim-bufferline.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('aceforeverd.apperance').bufferline()
    end,
  },
  {
    'stevearc/dressing.nvim',
    config = function()
      require('aceforeverd.plugins.enhance').dressing()
    end,
    event = 'VeryLazy',
  },

  {
    'danymat/neogen',
    config = function()
      require('neogen').setup({
        snippet_engine = 'luasnip',
      })
    end,
    cmd = 'Neogen',
  },

  {
    'rlane/pounce.nvim',
    cmd = { 'Pounce', 'PounceRepeat', 'PounceReg', 'PounceExpand' },
  },

  {
    'andythigpen/nvim-coverage',
    config = function()
      require('coverage').setup()
    end,
    lazy = true,
  },

  {
    'nvim-neotest/neotest',
    lazy = true,
  },

  -- color picker
  {
    'uga-rosa/ccc.nvim',
    config = function()
      require('ccc').setup({
        highlighter = {
          auto_enable = false,
        },
      })
    end,
    cmd = { 'CccPick', 'CccConvert', 'CccHighlighterToggle' },
  },

  {
    'dhananjaylatkar/cscope_maps.nvim',
    event = 'VeryLazy',
    dependencies = {
      'folke/which-key.nvim',
    },
    cond = function()
      return vim.fn.has('nvim-0.9') == 1
    end,
    config = function()
      require('cscope_maps').setup({
        disable_maps = true,
      })
    end,
  },

  { 'echasnovski/mini.nvim', lazy = true },
}

return M
