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

packer.reset()

return packer.startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }

  use { 'neovim/nvim-lspconfig', opt = true }

  use { 'nvim-lua/completion-nvim', opt = true }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 'nvim-treesitter/playground', requires = 'nvim-treesitter/nvim-treesitter' }

  use { 'romgrk/nvim-treesitter-context', requires = 'nvim-treesitter/nvim-treesitter' }

  use { 'p00f/nvim-ts-rainbow', reuters = 'nvim-treesitter/nvim-treesitter' }

  use { 'nvim-treesitter/nvim-treesitter-textobjects', requires = 'nvim-treesitter/nvim-treesitter' }

  use { 'nvim-treesitter/nvim-treesitter-refactor', requires = 'nvim-treesitter/nvim-treesitter' }

  use { 'tjdevries/nlua.nvim', ft = { 'lua' } }

  use { 'rafcamlet/nvim-luapad', ft = { 'lua' } }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
  }

  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }

  use { 'phaazon/hop.nvim' }

  use { 'marko-cerovac/material.nvim' }

  use { 'mfussenegger/nvim-dap' }

  use { 'sindrets/diffview.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }

end)

