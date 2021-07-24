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
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path})
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

    use { 'neovim/nvim-lspconfig', opt = true }

    use { 'nvim-lua/completion-nvim', opt = true }

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

    use { 'nvim-treesitter/nvim-tree-docs', requires = { 'nvim-treesitter/nvim-treesitter' } }

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
        vim.api.nvim_set_keymap('n', '<Leader>f', '<Cmd>Telescope<CR>',
                                { noremap = true, silent = false })
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
      config = function() require('aceforeverd.plugins.nvim-tree') end
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

    use { 'dstein64/nvim-scrollview', opt = true }

    use { 'notomo/gesture.nvim', opt = true }

    use { "npxbr/glow.nvim", ft = { 'markdown' } }

    use {
      'pwntester/octo.nvim',
      requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
      config = function() require"octo".setup() end,
      cmd = { 'Octo', 'OctoAddReviewComment', 'OctoAddReviewSuggestion' }
    }

    use { 'Pocco81/HighStr.nvim' }

    use {
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end,
      config = function() require('aceforeverd.plugins.bufferline') end
    }

    use {
      'kevinhwang91/nvim-hlslens',
      config = function()
        vim.api.nvim_set_keymap('n', '*', "*<Cmd>lua require('hlslens').start()<CR>",
                                { silent = true, noremap = true })
      end
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

    use { 'famiu/nvim-reload' }

    use {
      'lewis6991/gitsigns.nvim',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end,
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() require('aceforeverd.plugins.gitsigns') end
    }

    use {
      'famiu/feline.nvim',
      cond = function() return vim.fn.has('nvim-0.6.0') == 1 end,
      requires = { 'kyazdani42/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
      config = function() require('aceforeverd.plugins.feline') end
    }

  end
})

