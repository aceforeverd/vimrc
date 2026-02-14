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
    vim.notify('installing lazy.nvim to ' .. lazypath .. ' ...', vim.log.levels.INFO, {})
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

  {
    'SmiteshP/nvim-navic',
    config = function()
      require('nvim-navic').setup({
        click = true, -- Single click to goto element, double click to open nvim-navbuddy
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
    cmd = { 'Navbuddy' },
    keys = { { '<space>v', '<cmd>Navbuddy<cr>', desc = 'navbuddy' } }
  },

  -- {
  --   'Bekaboo/dropbar.nvim',
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim'
  --   },
  --   cond = function()
  --     return vim.fn.has('nvim-0.10') == 1
  --   end
  -- },

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
    end,
    lazy = true,
  },

  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end
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
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  {
    -- LSP signature hint as you type
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    config = function()
      require('lsp_signature').setup({
        bind = true,
        handler_opts = {
          border = 'rounded',
        },
        transparency = 25,
        toggle_key = '<M-x>',
        select_signature_key = '<M-n>',
        move_cursor_key = '<M-m>',
      })
    end
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'p00f/clangd_extensions.nvim',
      -- lsp enhance
      'b0o/schemastore.nvim',
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('aceforeverd.lsp').setup()
    end,
  },

  -- installer
  {
    'williamboman/mason.nvim',
    opts = {},
    lazy = true,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = {
        exclude = {
          'jdtls',
          'gopls',
        }
      }
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
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
    'kosayoda/nvim-lightbulb',
    event = 'LspAttach',
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = {
          enabled = true,
          updatetime = 500,
        },
        ignore = {
          clients = {
            "metals" -- metals just giving too many hints
          }
        }
      })
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        -- tools = {}
        server = {
          default_settings = {
            -- rust-analyzer language server configuration
            -- ref https://rust-analyzer.github.io/manual.html#configuration
            ['rust-analyzer'] = {
              cargo = {},
              procMacro = {
                enable = true
              }
            },
          },
        },
        -- DAP configuration
        -- dap = {},
      }
    end
  },

  {
    'mrcjkb/haskell-tools.nvim',
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
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
        -- nvim hang if file too large, disable on large file
        large_file_cutoff = 10000, -- lines
      })

      vim.keymap.set('n', '<a-i>', function()
        require('illuminate').toggle_freeze_buf()
      end, { noremap = true, desc = 'Toggle freezing' })
    end,
    event = 'VeryLazy',
  },

  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('aceforeverd.plugins.null-ls').setup()
    end,
  },

  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        cpp = { 'cpplint' },
        c = { 'cpplint' },
        sh = {'shellcheck'},
        vim = { 'vint' },
        dockerfile = {'hadolint'},
        python = { 'pylint' },
        yaml = { 'actionlint' },
      }

      vim.api.nvim_create_user_command('Lint', function() require('lint').try_lint() end, {})
    end,
    cmd = { 'Lint' },
  },

  {
    'stevearc/conform.nvim',
    config = function(_, opts)
      local conform = require('conform')
      conform.setup(opts)

      vim.api.nvim_create_user_command('Conform', function()
        conform.format()
      end, { desc = 'format with conform.nvim' })
    end,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nginx = { 'nginxfmt' },
        sh = { 'shfmt', 'shellharden' },
        python = { 'yapf' },
        cmake = { 'cmake_format' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        json = { 'jq' },
        yaml = { 'yq', 'yamlfmt' },
      },
    },
    cmd = { 'ConformInfo', 'Conform' }
  },

  {
    "lewis6991/hover.nvim",
    config = function()
      require('hover').config({
        providers = {
          'hover.providers.diagnostic',
          'hover.providers.lsp',
          'hover.providers.dap',
          'hover.providers.man',
          'hover.providers.dictionary',
          -- Optional by default
          'hover.providers.gh',
          'hover.providers.gh_user',
          -- 'hover.providers.jira',
          -- 'hover.providers.fold_preview',
          -- 'hover.providers.highlight',
        },

        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
        mouse_providers = {
          'hover.providers.lsp',
        },
      })
    end,
    keys = {
      { ';K', function() require('hover').open() end, desc = 'hover.nvim (open)' },
      { ';gK', function() require('hover').enter() end, desc = 'hover.nvim (enter)' },
    }
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
      'hrsh7th/cmp-emoji',
      'ray-x/cmp-treesitter',
      'andersevenrud/cmp-tmux',
      'petertriho/cmp-git',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
      'octaltree/cmp-look',
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
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('aceforeverd.config.treesitter').setup_next()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    config = function()
      require('aceforeverd.config.treesitter').textobj()
    end
  },
  {
    'RRethy/nvim-treesitter-endwise',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
      -- disable vim-endwise
      vim.g.loaded_endwise = 1
    end
  },
  {
    'RRethy/nvim-treesitter-textsubjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = true, -- upstream not up-to-date
    config = function()
      require('nvim-treesitter-textsubjects').configure({
        prev_selection = ',',
        keymaps = {
          -- omap
          ['.'] = 'textsubjects-smart',
          ['a.'] = 'textsubjects-container-outer',
          ['i.'] = 'textsubjects-container-inner',
        },
      })
    end
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      -- still issue on tag rename for xml, fallback to tagalone
      vim.g.tagalong_filetypes = { 'xml' }

      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        }
      })
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })
      vim.keymap.set(
        'n',
        '<leader>uc',
        function() require('ts_context_commentstring.internal').update_commentstring() end,
        { silent = true, noremap = true, desc = 'update commentstring' }
      )
    end
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    submodules = false,
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
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
        blacklist = {
          'markdown', -- nvim freeze when opening large markdown, as a temporizingly solution
        },
      }
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },

  {
    'mizlan/iswap.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = true, -- require upstream work
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
      { ";s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { ";S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
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
        skipInsignificantPunctuation = false,
      })
    end,
    keys = {
      { mode = { 'n', 'o', 'x' }, '<localleader>w', "<cmd>lua require('spider').motion('w')<CR>",  desc = 'Spider-w: next word'  },
      { mode = { 'n', 'o', 'x' }, '<localleader>e', "<cmd>lua require('spider').motion('e')<CR>",  desc = 'Spider-e: end of word'  },
      { mode = { 'n', 'o', 'x' }, '<localleader>b', "<cmd>lua require('spider').motion('b')<CR>",  desc = 'Spider-b: previous word'  },
      { mode = { 'n', 'o', 'x' }, '<localleader>ge', "<cmd>lua require('spider').motion('ge')<CR>", desc = 'Spider-ge: previous end of word' },
    },
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
      'nvim-telescope/telescope-ui-select.nvim'
    },
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
    opts = {
      auto_preview = false,
    },
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

  -- UI
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = { 'VimEnter' },
    config = function()
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
    'folke/snacks.nvim',
    opts = {
      input = { enabled = true },
    }
  },

  {
    'luukvbaal/statuscol.nvim',
    config = function()
      require('aceforeverd.apperance').statuscolumn()
    end
  },

  {
    'stevearc/overseer.nvim',
    opts = {},
    cmd = { 'OverseerRun', 'OverseerRunCmd', 'OverseerBuild', 'OverseerTaskAction' }
  },

  -- colors
  {
    'catgoose/nvim-colorizer.lua',
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
    config = function()
      -- align
      require('mini.align').setup({
        mappings = {
          start = '<leader>ga',
          start_with_preview = '<leader>gA',
        }
      })
    end,
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
      { "<leader>mf", function() require('mini.files').open() end, desc = 'mini files' },
      "<leader>ga",
      "<leader>gA",
    },
  },

  {
    "chrisgrieser/nvim-rulebook",
    keys = {
      { "<leader>ri", function() require('rulebook').ignoreRule() end,        desc = 'ignore rule' },
      { "<leader>rl", function() require('rulebook').lookupRule() end,        desc = 'lookup rule' },
      { "<leader>ry", function() require("rulebook").yankDiagnosticCode() end }
    }
  },

  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        engine = 'ripgrep'
      })
    end,
    cmd = { 'GrugFar' }
  },

  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua"
    },
    config = function()
      require("yaml_nvim").setup({ ft = { "yaml" } })
    end
  },
  {
    "qvalentin/helm-ls.nvim",
    ft = { "helm", "yaml.helm-values" },
    opts = {},
  },

  ---   AI staff --------
  {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- this file can contain specific instructions for your project
      instructions_file = "avante.md",
      -- for example
      provider = "gemini-cli",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
      ["gemini-cli"] = {
        command = "gemini",
        args = { "--experimental-acp" },
        env = {
          NODE_NO_WARNINGS = "1",
          GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
        },
      },
    },
    dependencies = {
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },
  },
  {
    -- support for image pasting
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- recommended settings
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = true, -- required for Windows users
      },
    },
  },
}
return M
