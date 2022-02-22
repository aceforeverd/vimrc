-- Copyright (C) 2021  Ace <teapot@aceforeverd.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- local default_setup = require('feline.presets.default')
local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local b = vim.b
local fn = vim.fn

local icons = { UNIX = '', MAC = '', WINDOWS = '' }

local palette = vim.api.nvim_call_function('sonokai#get_palette', { vim.g.sonokai_style })

local bit_green = palette.bg_green[1]
local bit_blue = palette.bg_blue[1]
local bit_yellow = '#e5c463'
local bit_red = palette.bg_red[1]

-- TODO: add some short_provider & icon

function OsIcon()
  if vim.fn.has('mac') == 1 then
    return icons.MAC
  elseif vim.fn.has('unix') == 1 then
    return icons.UNIX
  elseif vim.fn.has('win32') == 1 then
    return icons.WINDOWS
  end
end

local gitsigns_has_diff = function()
  local dict = vim.b.gitsigns_status_dict
  if dict == nil then
    return false
  end
  return dict.added ~= 0 or dict.changed ~= 0 or dict.removed ~= 0
end

local vi_mode_hl = function()
  return {
    name = vi_mode_utils.get_mode_highlight_name(),
    fg = 'black',
    bg = vi_mode_utils.get_mode_color(),
    style = 'bold',
  }
end

local feline_config = {
  default_bg = '#282c34',
  components = {
    active = {
      { -- left
        {
          provider = function()
            return '  ' .. vi_mode_utils.get_vim_mode()
          end,
          hl = vi_mode_hl,
          right_sep = { str = ' ', hl = vi_mode_hl },
        },
        {
          provider = 'git_branch',
          hl = { fg = 'black', bg = bit_blue, style = 'bold' },
          enabled = function()
            return b.gitsigns_status_dict ~= nil
          end,
          left_sep = { { str = 'block', hl = { fg = bit_blue } } },
          right_sep = { { str = 'block', hl = { fg = bit_blue } } },
        },
        { provider = 'git_diff_added', hl = { fg = 'green', bg = 'black' } },
        { provider = 'git_diff_changed', hl = { fg = 'orange', bg = 'black' } },
        { provider = 'git_diff_removed', hl = { fg = 'red', bg = 'black' } },
        {
          -- right seperator for git diffs
          provider = ' ┃ ',
          hl = { fg = 'violet', bg = 'black' },
          enabled = gitsigns_has_diff,
        },
        {
          provider = 'diagnostic_errors',
          enabled = function()
            return lsp.diagnostics_exist('ERROR')
          end,
          hl = { fg = 'red' },
        },
        {
          provider = 'diagnostic_warnings',
          enabled = function()
            return lsp.diagnostics_exist('WARN')
          end,
          hl = { fg = 'yellow' },
        },
        {
          provider = 'diagnostic_hints',
          enabled = function()
            return lsp.diagnostics_exist('HINT')
          end,
          hl = { fg = 'cyan' },
        },
        {
          provider = 'diagnostic_info',
          enabled = function()
            return lsp.diagnostics_exist('INFO')
          end,
          hl = { fg = 'skyblue' },
        },
        {
          -- right separator for builtin lsp diagnostics
          provider = ' ┃',
          enabled = function()
            return #vim.diagnostic.get(0) ~= 0
          end,
          hl = { fg = 'green', bg = 'black' },
        },
        {
          -- for neovim 0.6.0 or later, use built-in lsp, otherwise coc
          provider = function()
            return vim.api.nvim_eval('coc#status()')
          end,
          left_sep = ' ',
          enabled = function()
            return vim.g.my_cmp_source == 'coc'
          end,
        },
        {
          provider = 'my_lsp_client_names',
          enabled = function()
            return vim.g.my_cmp_source == 'nvim_lsp'
          end,
          hl = { fg = 'orange' },
          left_sep = ' ',
        },
        {
          provider = function()
            return require('lsp-status').status()
          end,
          left_sep = ' ',
          enabled = function()
            return vim.g.my_cmp_source == 'nvim_lsp'
          end,
        },
      },
      {}, -- mid
      { -- right
        {
          provider = function()
            return require('aceforeverd.utility.statusline').gps()
          end,
          hl = { fg = '#fda5b4' },
          right_sep = ' ',
        },
        {
          provider = 'file_type',
          hl = { fg = 'cyan', style = 'bold,italic' },
          left_sep = { { str = 'vertical_bar', hl = { fg = '#108080' } }, ' ' },
          right_sep = { ' ' },
        },
        {
          provider = OsIcon(),
          left_sep = { { str = 'vertical_bar', hl = { fg = '#666666' } }, ' ' },
          hl = { fg = '#cccccc' },
        },
        {
          provider = 'file_encoding',
          left_sep = { ' ' },
          right_sep = { ' ', { str = 'vertical_bar', hl = { bg = 'NONE' } } },
          hl = { fg = '#ffff0a' },
        },
        {
          provider = function()
            return vim.o.spelllang
          end,
          enabled = function()
            return vim.o.spell == true
          end,
          right_sep = { str = 'vertical_bar', hl = { fg = 'magenta' } },
          hl = { fg = 'magenta' },
        },
        {
          provider = 'position',
          hl = { fg = 'skyblue' },
          left_sep = { ' ' },
          right_sep = { ' ', { str = 'vertical_bar', hl = { fg = 'NONE' } } },
        },
        {
          provider = 'file_size',
          enabled = function()
            return fn.getfsize(fn.expand('%:p')) > 0
          end,
          hl = { fg = 'green' },
          left_sep = { ' ' },
          right_sep = { ' ', { str = 'vertical_bar', hl = { fg = '#89f4ff' } } },
        },
        {
          provider = 'line_percentage',
          hl = { fg = 'orange', style = 'bold' },
          left_sep = ' ',
          right_sep = ' ',
        },
        { provider = 'scroll_bar', hl = { fg = 'skyblue', style = 'bold' } },
      },
    },
    inactive = {
      { -- left
        {
          provider = function()
            return '  ' .. vi_mode_utils.get_vim_mode()
          end,
          hl = vi_mode_hl,
          right_sep = { str = ' ', hl = vi_mode_hl },
        },
        {
          provider = 'file_type',
          hl = {
            fg = 'white',
            bg = 'oceanblue',
            style = 'bold',
          },
          left_sep = {
            str = ' ',
            hl = {
              fg = 'NONE',
              bg = 'oceanblue',
            },
          },
          right_sep = {
            {
              str = ' ',
              hl = {
                fg = 'NONE',
                bg = 'oceanblue',
              },
            },
            'slant_right',
          },
        },
      },
      {}, -- right
    },
  },
  force_inactive = {
    filetypes = {
      '^NvimTree$',
      '^coc-explorer$',
      '^startify$',
      '^vim-plug$',
    },
    buftypes = {},
    bufnames = {},
  },
  custom_providers = {
    my_lsp_client_names = require('aceforeverd.utility.statusline').lsp_client_names,
  },
}

require('feline').setup(feline_config)
