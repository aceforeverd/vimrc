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
          numhl = true,
          linehl = false,
          watch_index = { interval = 1000 },
          attach_to_untracked = false,
          current_line_blame = false,
          sign_priority = 6,
          update_debounce = 100,
          status_formatter = nil, -- Use default
          use_decoration_api = true,
          use_internal_diff = true -- If luajit is present
        }
      end
    }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use { 'nvim-treesitter/playground', requires = 'nvim-treesitter/nvim-treesitter' }

    use {
      'romgrk/nvim-treesitter-context',
      requires = 'nvim-treesitter/nvim-treesitter',
      config = function()
        require'treesitter-context.config'.setup {
          enable = true -- Enable this plugin (Can be enabled/disabled later via commands)
        }
      end
    }

    use { 'p00f/nvim-ts-rainbow', requires = 'nvim-treesitter/nvim-treesitter' }

    use {
      'nvim-treesitter/nvim-treesitter-textobjects',
      requires = 'nvim-treesitter/nvim-treesitter'
    }

    use { 'nvim-treesitter/nvim-treesitter-refactor', requires = 'nvim-treesitter/nvim-treesitter' }

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
                                "<Cmd>lua require('telescope').extensions.packer.plugins()<CR>",
                                { noremap = true, silent = true })
      end
    }

    use {
      'nvim-telescope/telescope-project.nvim',
      requires = { 'nvim-telescope/telescope.nvim' },
      config = function()
        vim.api.nvim_set_keymap('n', '<Leader>tj',
                                "<Cmd>lua require'telescope'.extensions.project.project{}<CR>",
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
    use {
      "rcarriga/nvim-dap-ui",
      requires = { "mfussenegger/nvim-dap" },
      config = function() require("dapui").setup() end
    }

    use {
      'TimUntersberger/neogit',
      config = function() require('neogit').setup {} end,
      cmd = 'Neogit'
    }

    use { 'sindrets/diffview.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

    use { 'tversteeg/registers.nvim' }

    use { 'rafamadriz/neon' }

    -- use { 'dstein64/nvim-scrollview' }

    use { 'notomo/gesture.nvim', opt = true }

    use {
      'pwntester/octo.nvim',
      requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
      config = function() require"octo".setup() end
    }

    use { 'Pocco81/HighStr.nvim' }

    use { 'romgrk/barbar.nvim', opt = true }
    use { 'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons', opt = true }
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
      requires = { 'kyazdani42/nvim-web-devicons', 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require'lualine'.setup {
          options = {
            icons_enabled = true,
            theme = 'material',
            component_separators = { '', '' },
            section_separators = { '', '' },
            disabled_filetypes = { 'coc-explorer' }
          },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff' },
            lualine_c = { { 'filename', file_status = true }, 'coc#status' },
            lualine_x = { 'b:coc_current_function', 'filetype', 'fileformat', 'encoding' },
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

