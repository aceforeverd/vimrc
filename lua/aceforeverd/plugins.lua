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
vim.cmd [[ packadd packer.nvim ]]

local packer = require('packer')

local util = require('packer.util')
packer.init({
  package_root = util.join_paths(config_path, 'bundle/pack'),
  compile_path = util.join_paths(config_path, 'plugin', 'packer_compiled.vim'),
  plugin_package = 'packer'
})

return packer.startup({
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    use { 'neovim/nvim-lspconfig', opt = true }

    use { 'nvim-lua/completion-nvim', opt = true }

    use {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitsigns').setup {
          signs = {
            add = {
              hl = 'GitSignsAdd',
              text = '│',
              numhl = 'GitSignsAddNr',
              linehl = 'GitSignsAddLn'
            },
            change = {
              hl = 'GitSignsChange',
              text = '│',
              numhl = 'GitSignsChangeNr',
              linehl = 'GitSignsChangeLn'
            },
            delete = {
              hl = 'GitSignsDelete',
              text = '_',
              numhl = 'GitSignsDeleteNr',
              linehl = 'GitSignsDeleteLn'
            },
            topdelete = {
              hl = 'GitSignsDelete',
              text = '‾',
              numhl = 'GitSignsDeleteNr',
              linehl = 'GitSignsDeleteLn'
            },
            changedelete = {
              hl = 'GitSignsChange',
              text = '~',
              numhl = 'GitSignsChangeNr',
              linehl = 'GitSignsChangeLn'
            }
          },
          numhl = true,
          linehl = false,
          keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,

            ['n ]c'] = {
              expr = true,
              "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"
            },
            ['n [c'] = {
              expr = true,
              "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"
            },

            ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ['n <leader>bb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

            -- Text objects
            ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
            ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
          },
          watch_index = { interval = 1000 },
          current_line_blame = false,
          sign_priority = 6,
          update_debounce = 100,
          status_formatter = nil, -- Use default
          use_decoration_api = true,
          use_internal_diff = true -- If luajit is present
        }
      end
    }

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
          ignore_install = {}, -- List of parsers to ignore installing
          highlight = {
            enable = true, -- false will disable the whole extension
            disable = { 'yaml' } -- list of language that will be disabled
          },
          indent = { enable = true, disable = { 'yaml' } },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm"
            }
          },
          matchup = { enable = true },
          query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" }
          },
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?'
            }
          },
          rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
          refactor = {
            highlight_definitions = { enable = true },
            highlight_current_scope = { enable = true, disable = { 'c', 'cpp', 'yaml', 'lua' } },
            smart_rename = { enable = true, keymaps = { smart_rename = "<Leader>rt" } },
            navigation = {
              enable = true,
              keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>"
              }
            }
          },
          textobjects = {
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              -- ']' -> next, '[' -> previous,
              -- lowercase -> next/previous start, uppercase -> next/previous end
              goto_next_start = { -- ']'
                ["}k"] = "@block.inner",
                ["]k"] = "@block.outer",
                ["}g"] = "@call.inner",
                ["]g"] = "@call.outer",
                ["}]"] = "@class.inner",
                ["]]"] = "@class.outer",
                ["]/"] = "@comment.outer",
                ["}j"] = "@conditional.inner",
                ["]j"] = "@conditional.outer",
                ["}m"] = "@function.inner",
                ["]m"] = "@function.outer",
                ["}w"] = "@loop.inner",
                ["]w"] = "@loop.outer",
                ["}r"] = "@parameter.inner",
                ["]r"] = "@parameter.outer",
                ["];"] = "@statement.outer"
              },
              goto_next_end = { -- '>'
                ["}K"] = "@block.inner",
                ["]K"] = "@block.outer",
                ["}G"] = "@call.inner",
                ["]G"] = "@call.outer",
                ["}["] = "@class.inner",
                ["]["] = "@class.outer",
                ["}/"] = "@comment.outer",
                ["}J"] = "@conditional.inner",
                ["]J"] = "@conditional.outer",
                ["}M"] = "@function.inner",
                ["]M"] = "@function.outer",
                ["}W"] = "@loop.inner",
                ["]W"] = "@loop.outer",
                ["}R"] = "@parameter.inner",
                ["]R"] = "@parameter.outer",
                ["};"] = "@statement.outer"
              },
              goto_previous_start = { -- '['
                ["{k"] = "@block.inner",
                ["[k"] = "@block.outer",
                ["{g"] = "@call.inner",
                ["[g"] = "@call.outer",
                ["{["] = "@class.inner",
                ["[["] = "@class.outer",
                ["[/"] = "@comment.outer",
                ["{j"] = "@conditional.inner",
                ["[j"] = "@conditional.outer",
                ["{m"] = "@function.inner",
                ["[m"] = "@function.outer",
                ["{w"] = "@loop.inner",
                ["[w"] = "@loop.outer",
                ["{r"] = "@parameter.inner",
                ["[r"] = "@parameter.outer",
                ["[;"] = "@statement.outer"
              },
              goto_previous_end = { -- '<'
                ["{K"] = "@block.inner",
                ["[K"] = "@block.outer",
                ["{G"] = "@call.inner",
                ["[G"] = "@call.outer",
                ["{]"] = "@class.inner",
                ["[]"] = "@class.outer",
                ["{/"] = "@comment.outer",
                ["{J"] = "@conditional.inner",
                ["[J"] = "@conditional.outer",
                ["{M"] = "@function.inner",
                ["[M"] = "@function.outer",
                ["{W"] = "@loop.inner",
                ["[W"] = "@loop.outer",
                ["{R"] = "@parameter.inner",
                ["[R"] = "@parameter.outer",
                ["{;"] = "@statement.outer"
              }
            }
          }
        }
      end
    }

    use { 'nvim-treesitter/playground', requires = 'nvim-treesitter/nvim-treesitter' }

    use { 'romgrk/nvim-treesitter-context', requires = 'nvim-treesitter/nvim-treesitter' }

    use { 'p00f/nvim-ts-rainbow', reuters = 'nvim-treesitter/nvim-treesitter' }

    use {
      'nvim-treesitter/nvim-treesitter-textobjects',
      requires = 'nvim-treesitter/nvim-treesitter'
    }

    use { 'nvim-treesitter/nvim-treesitter-refactor', requires = 'nvim-treesitter/nvim-treesitter' }

    use { 'tjdevries/nlua.nvim', ft = { 'lua' } }

    use { 'rafcamlet/nvim-luapad', ft = { 'lua' } }

    use {
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
      config = function()
        require('telescope').setup {
          defaults = {
            mappings = {
              i = {
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous
              }
            },
            vimgrep_arguments = {
              'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column',
              '--smart-case'
            }
          }
        }
      end
    }

    use {
      'nvim-telescope/telescope-packer.nvim',
      requires = { 'nvim-telescope/telescope.nvim' },
      config = function()
        vim.api.nvim_set_keymap('n', '<Leader>tp',
                                ":lua require('telescope').extensions.packer.plugins()<cr>",
                                { noremap = true, silent = true })
      end
    }

    use {
      'nvim-telescope/telescope-project.nvim',
      requires = { 'nvim-telescope/telescope.nvim' },
      config = function()
        vim.api.nvim_set_keymap('n', '<Leader>tj',
                                ":lua require'telescope'.extensions.project.project{}<CR>",
                                { noremap = true, silent = true })
      end
    }

    use {
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        vim.api.nvim_set_keymap('n', '<Space>r', [[ <Cmd>lua require 'nvim-tree'.toggle()<CR> ]],
                                { noremap = true, silent = false })

      end
    }

    use { 'phaazon/hop.nvim' }

    use {
      'marko-cerovac/material.nvim',
      config = function()
        vim.g.material_style = 'darker'
        vim.g.material_borders = true
        vim.g.material_variable_color = '#3adbc5'
        require('material').set()
        vim.api.nvim_set_keymap('n', '<c-n>',
                                [[<Cmd>lua require('material.functions').toggle_style()<CR>]],
                                { noremap = true, silent = true })
      end
    }

    use { 'mfussenegger/nvim-dap' }

    use { 'sindrets/diffview.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

    use { 'tversteeg/registers.nvim' }

    use { 'rafamadriz/neon' }

    use { 'dstein64/nvim-scrollview' }

    use { 'notomo/gesture.nvim', opt = true }

    use {
      'pwntester/octo.nvim',
      requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
      config = function() require"octo".setup() end
    }

    use { 'Pocco81/HighStr.nvim' }

    use { 'romgrk/barbar.nvim', opt = true }
    use { 'kevinhwang91/nvim-hlslens' }

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

    use { 'famiu/nvim-reload' }

    use {
      'hoob3rt/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require'lualine'.setup {
          options = {
            icons_enabled = true,
            theme = 'material',
            component_separators = { '', '' },
            section_separators = { '', '' },
            disabled_filetypes = {}
          },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff' },
            lualine_c = { 'filename', 'coc#status' },
            lualine_x = { 'filetype', 'fileformat', 'encoding' },
            lualine_y = {
              {
                'diagnostics',
                sources = { 'coc' },
                -- displays diagnostics from defined severity
                sections = { 'error', 'warn', 'info', 'hint' },
                -- all colors are in format #rrggbb
                color_error = nil, -- changes diagnostic's error foreground color
                color_warn = nil, -- changes diagnostic's warn foreground color
                color_info = nil, -- Changes diagnostic's info foreground color
                color_hint = nil, -- Changes diagnostic's hint foreground color
                symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
              }
            },
            lualine_z = { 'location', 'progress' }
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = { 'branch', 'diff' },
            lualine_c = { 'filename' },
            lualine_x = { 'filetype', 'fileformat', 'encoding' },
            lualine_y = {
              {
                'diagnostics',
                sources = { 'coc' },
                -- displays diagnostics from defined severity
                sections = { 'error', 'warn', 'info', 'hint' },
                -- all colors are in format #rrggbb
                color_error = nil, -- changes diagnostic's error foreground color
                color_warn = nil, -- changes diagnostic's warn foreground color
                color_info = nil, -- Changes diagnostic's info foreground color
                color_hint = nil, -- Changes diagnostic's hint foreground color
                symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
              }
            },
            lualine_z = {}
          },
          tabline = {},
          extensions = { 'fugitive', 'fzf' }
        }
      end
    }

  end
})

