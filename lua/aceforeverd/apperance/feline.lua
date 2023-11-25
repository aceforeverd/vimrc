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

local palette = require('aceforeverd.apperance.helper')
local bit_green = palette.bit_green
local bit_blue = palette.bit_blue
local bit_yellow = palette.bit_yellow
local bit_red = palette.bit_red

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

-- define priority for components, lower truncated first
-- default priority is 0
local priority_high = 10
local priority_med = 5
local priority_low = -10

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
          priority = priority_high,
        },
        {
          provider = function()
            return vim.fn['aceforeverd#statusline#props']()
          end,
          hl = vi_mode_hl,
          right_sep = { str = ' ', hl = vi_mode_hl },
          priority = priority_high,
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
          priority = priority_med,
          hl = { fg = 'red' },
        },
        {
          provider = 'diagnostic_warnings',
          enabled = function()
            return lsp.diagnostics_exist('WARN')
          end,
          priority = priority_med,
          hl = { fg = 'yellow' },
        },
        {
          provider = 'diagnostic_hints',
          enabled = function()
            return lsp.diagnostics_exist('HINT')
          end,
          icon = ' ',
          priority = priority_med,
          hl = { fg = 'cyan' },
        },
        {
          provider = 'diagnostic_info',
          enabled = function()
            return lsp.diagnostics_exist('INFO')
          end,
          priority = priority_med,
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
          priority = priority_low,
        },
        {
          provider = 'my_lsp_client_names',
          hl = { fg = 'orange' },
          left_sep = ' ',
          enabled = function()
            return vim.g.my_cmp_source == 'nvim_lsp'
          end,
          priority = priority_low,
        },
        {
          provider = 'lsp_status',
          left_sep = ' ',
          enabled = function()
            return vim.g.my_cmp_source == 'nvim_lsp'
          end,
          priority = priority_low,
        },
      },
      {}, -- mid
      { -- right
        {
          provider = 'gps',
          short_provider = {
            name = 'gps',
            opts = {
              short = true,
            },
          },
          enabled = function()
            -- otherwise it will appear in winbar
            return vim.fn.exists('+winbar') == 0
          end,
          hl = { fg = '#fda5b4' },
          right_sep = ' ',
          -- FIXME: get_location seems not work
          truncate_hide = true,
          priority = priority_low,
        },
        {
          provider = 'tag_status'
        },
        {
          provider = 'file_type',
          hl = { fg = 'cyan', style = 'bold,italic' },
          left_sep = { { str = 'vertical_bar', hl = { fg = '#108080' } }, ' ' },
          right_sep = { ' ' },
          priority = priority_high,
        },
        {
          provider = OsIcon(),
          left_sep = { { str = 'vertical_bar', hl = { fg = '#666666' } }, ' ' },
          hl = { fg = '#cccccc' },
          truncate_hide = true,
          priority = priority_low,
        },
        {
          provider = 'file_encoding',
          left_sep = { ' ' },
          right_sep = { ' ', { str = 'vertical_bar', hl = { bg = 'NONE' } } },
          hl = { fg = '#ffff0a' },
          priority = priority_low,
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
          priority = priority_low,
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
        {
          provider = 'scroll_bar',
          hl = { fg = 'skyblue', style = 'bold' },
          priority = priority_low,
        },
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
    lsp_status = require('aceforeverd.util.statusline').lsp_status,
    my_lsp_client_names = require('aceforeverd.util.statusline').lsp_client_names,
    gps = require('aceforeverd.util.statusline').ctx_location,
    tag_status = require('aceforeverd.util.statusline').tag_status,
  },
}

local function gen_winbar_components()
  return {
    active = {
      -- left
      {
        {
          provider = { name = 'file_info', opts = { type = 'relative' } },
          short_provider = { name = 'file_info', opts = { type = 'relative-short' } },
          hl = { fg = bit_green },
        },
        {
          provider = function()
            return require('aceforeverd.util.statusline').ctx_location()
          end,
          left_sep = { { str = ' :: ', hl = { fg = bit_yellow } } },
          hl = { fg = 'orange' },
        },
      },
    },
  }
end

return {
  setup = function()
    require('feline').setup(feline_config)
    if vim.fn.exists('+winbar') ~= 0 then
      require('feline').winbar.setup({
        components = gen_winbar_components(),
      })
    end
  end,
}
