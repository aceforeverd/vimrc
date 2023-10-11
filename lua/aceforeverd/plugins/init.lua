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
        diagnostics = false,
      })

      lsp_status.register_progress()
    end,
    lazy = true,
  },

  {
    'p00f/clangd_extensions.nvim',
    config = function()
      require('clangd_extensions').setup({
        inlay_hints = {
          highlight = 'LspInlayHint'
        }
      })
    end,
    lazy = true,
  },
  {
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup({
        library = {
          enabled = true,
          plugins = {
            'plenary.nvim',
            'nvim-lspconfig',
            'nvim-treesitter',
            'telescope.nvim',
            'nvim-web-devicons',
            'nui.nvim',
            'sqlite.lua',
          },
        },
        lspconfig = true,
        pathStrict = true,
      })
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
      'SmiteshP/nvim-navic',
      'SmiteshP/nvim-navbuddy',
      'MunifTanjim/nui.nvim',
      -- statusline
      'nvim-lua/lsp-status.nvim',
    },
    config = function()
      require('aceforeverd.lsp').setup()
    end,
  },

  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      require('aceforeverd.lsp').jdtls()
    end,
  },

  {
    'scalameta/nvim-metals',
    ft = { 'scala', 'sbt' },
    config = function()
      require('aceforeverd.lsp').metals()
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
        require('illuminate').toggle_freeze_buf()
      end, { noremap = true, desc = 'Toggle freezing' })
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
    'uga-rosa/cmp-dictionary',
    config = function()
      local dict = require('cmp_dictionary')

      dict.setup({
        exact = 2,
        capacity = 5,
        debug = false,
      })
      dict.switcher({
        spelllang = {
          en = { '/usr/share/dict/words' },
          en_US = { '/usr/share/dict/words' },
        }
      })
      -- required since it loads from InsertEnter
      vim.cmd("CmpDictionaryUpdate")
    end,
    lazy = true,
  },
  {
    'petertriho/cmp-git',
    config = function()
      require('cmp_git').setup({
        filetypes = { 'gitcommit', 'markdown', 'octo' },
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
      'onsails/lspkind.nvim',
    },
    event = 'InsertEnter',
    config = function()
      require('aceforeverd.config').cmp()
    end,
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
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local luasnip = require('luasnip')
      -- local types = require('luasnip.util.types')
      luasnip.config.setup({
        ext_opts = {
          history = true,
          -- [types.choiceNode] = {
          --     active = {
          --         virt_text = { { '●', 'DiffAdd' } },
          --     },
          -- },
          -- [types.insertNode] = {
          --     active = {
          --         virt_text = { { '●', 'DiffDelete' } },
          --     },
          -- },
        },
      })

      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_snipmate').lazy_load()

      -- keymaps defined in nvim-cmp.lua
    end,
    build = 'make install_jsregexp',
  },

  -- ==============================================
  --        TREESITTER START
  -- ==============================================

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
      'RRethy/nvim-treesitter-endwise',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    config = function()
      require('aceforeverd.config').treesitter()
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
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

      local group = vim.api.nvim_create_augroup('MySplitJoin', { clear = true })
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        group = group,
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

  {
    'mfussenegger/nvim-treehopper',
    keys = {
      { '<space>', [[:<C-U>lua require('tsht').nodes()<CR>]], mode = 'o', { silent = true } },
      { '<space>', [[:lua require('tsht').nodes()<cr>]],      mode = 'x', { silent = true, noremap = true } },
    },
  },

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
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter', },
    config = function()
      require('neogen').setup({
        snippet_engine = 'luasnip',
      })
    end,
    cmd = 'Neogen',
  },

  -- ==============================================
  --        TREESITTER END
  -- ==============================================

  -- ==============================================
  --        MOTIONS START
  -- ==============================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false
        }
      }
    },
    -- stylua: ignore
    keys = {
      -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      -- { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o"}, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<M-l>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    'chrisgrieser/nvim-various-textobjs',
    config = function()
      require('various-textobjs').setup({ useDefaultKeymaps = false })
    end,
    keys = {
      { 'aS', mode = { 'o', 'x' }, '<cmd>lua require("various-textobjs").subword(false)<CR>', desc = 'around subword' },
      { 'iS', mode = { 'o', 'x' }, '<cmd>lua require("various-textobjs").subword(true)<CR>', desc = 'inside subword' },
      { '!', mode = { 'o', 'x' }, '<cmd>lua require("various-textobjs").diagnostic()<CR>', desc = 'diagnostics textobj' },
      { 'ii', mode = { "o", "x" }, "<cmd>lua require('various-textobjs').indentation(true, true)<CR>", desc = 'inner-inner indentation (no line above/below)'},
      { 'iI', mode = { "o", "x" }, "<cmd>lua require('various-textobjs').indentation(true, false)<CR>", desc = 'inner-outer indentation (no line above)'},
      { 'ai', mode = { "o", "x" }, "<cmd>lua require('various-textobjs').indentation(false, true)<CR>", desc = 'outer-inner indentation (include above)'},
      { 'aI', mode = { "o", "x" }, "<cmd>lua require('various-textobjs').indentation(false, false)<CR>", desc = 'outer-outer indentation (include above/below)'},
      { 'aD', mode = { 'o', 'x'}, "<cmd>lua require('various-textobjs').doubleSquareBrackets(false)<cr>", desc = "around doubleSquareBrackets"},
      { 'iD', mode = { 'o', 'x'}, "<cmd>lua require('various-textobjs').doubleSquareBrackets(true)<cr>", desc = "inside doubleSquareBrackets"},
      { 'in', mode = { 'o', 'x'}, "<cmd>lua require('various-textobjs').number(true)<cr>", desc = "inside number"},
      { 'an', mode = { 'o', 'x'}, "<cmd>lua require('various-textobjs').number(false)<cr>", desc = "around number"},
      { 'i$', mode = { 'o', 'x'}, "<cmd>lua require('various-textobjs').nearEoL()<cr>", desc = "till before last char of line"},
    },
  },

  {
    'chrisgrieser/nvim-spider',
    config = function()
      require('spider').setup({
        skipInsignificantPunctuation = true,
      })
    end,
    keys = {
      { mode = { 'n', 'o', 'x' }, 'w', "<cmd>lua require('spider').motion('w')<CR>",  desc = 'Spider-w: next word'  },
      { mode = { 'n', 'o', 'x' }, 'e', "<cmd>lua require('spider').motion('e')<CR>",  desc = 'Spider-e: end of word'  },
      { mode = { 'n', 'o', 'x' }, 'b', "<cmd>lua require('spider').motion('b')<CR>",  desc = 'Spider-b: previous word'  },
      { mode = { 'n', 'o', 'x' }, 'ge', "<cmd>lua require('spider').motion('ge')<CR>", desc = 'Spider-ge: previous end of word' },
    },
  },

  {
    'rlane/pounce.nvim',
    cmd = { 'Pounce', 'PounceRepeat', 'PounceReg', 'PounceExpand' },
  },
  -- ==============================================
  --        MOTIONS END
  -- ==============================================

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
  },

  { 'Olical/conjure', ft = { 'clojure', 'fennel', 'janet', 'racket', 'scheme' } },

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('aceforeverd.plugins.enhance').indent_blankline()
    end,
  },

  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', lazy = true },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('aceforeverd.config').teelscope()
    end,
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',

      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-github.nvim',
      'cljoly/telescope-repo.nvim',
      'jvgrootveld/telescope-zoxide',
      'nvim-telescope/telescope-frecency.nvim',
      'kkharji/sqlite.lua',
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        manual_mode = false,
        silent_chdir = true,
        scope_chdir = 'win',
        detection_methods = { 'pattern', 'lsp' },
      })
    end,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
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

  {
    'kevinhwang91/nvim-bqf',
    ft = { 'qf' },
    config = function()
      require('bqf').setup({
        preview = {
          auto_preview = false,
        },
      })
    end
  },

  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup({ show_numbers = true, show_cursorline = true, number_only = false })
    end,
  },

  {
    'NeogitOrg/neogit',
    config = function()
      require('neogit').setup({})
    end,
    cmd = 'Neogit',
  },

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('diffview').setup({
        enhanced_diff_hl = true,
      })
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
      require('octo').setup({
        user_icon = '👴',
        timeline_marker = '📣',
      })
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
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({
        plugins = { registers = true },
      })
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
      require('fzf-lua').setup({ winopts = { width = 0.9 } })

      vim.keymap.set('n', '<space>l', [[<cmd>FzfLua<cr>]], { desc = 'FzfLua' })
      vim.keymap.set('n', '<space>f', [[<cmd>FzfLua files<cr>]], { desc = 'FzfLua files' })
      vim.keymap.set('n', '<space>r', [[<cmd>FzfLua grep_project<cr>]], { desc = 'FzfLua Rg' })
      vim.keymap.set('n', '<space>T', [[<cmd>FzfLua tags<cr>]], { desc = 'FzfLua Tags' })
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    cmd = { 'Trouble', 'TroubleToggle' }
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

  -- UI
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = { 'VimEnter' },
    config = function ()
      local cfg = require('alpha.themes.startify')
      -- go https://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something
      local logo = [[
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]
      cfg.section.header.val = vim.split(logo, "\n")
      require('alpha').setup(cfg.config)
    end
  },

  {
    'freddiehaddad/feline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/lsp-status.nvim',
    },
    cond = function()
      return vim.g.my_statusline == 'feline'
    end,
    config = function()
      require('aceforeverd.apperance').feline()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/lsp-status.nvim',
    },
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
      require('dressing').setup({
        input = {
          border = 'rounded',
          win_options = {
            winblend = 10,
          },
        },
      })
    end,
    event = 'VeryLazy',
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

  {
    'stevearc/overseer.nvim',
    opts = {},
  },

  -- colors
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({})
    end,
    ft = { 'css', 'html' },
  },

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
    cond = function()
      return vim.fn.has('nvim-0.9') == 1
    end,
    config = function()
      require('aceforeverd.integration.cscope').cscope_maps()
    end,
  },

  {
    'echasnovski/mini.nvim',
    lazy = true,
  },
}

return M
