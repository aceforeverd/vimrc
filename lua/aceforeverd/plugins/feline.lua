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

local icons = { UNIX = '', MAC = '', WINDOWS = '' }

function OsIcon()
  if vim.fn.has('mac') == 1 then
    return icons.MAC
  elseif vim.fn.has('unix') == 1 then
    return icons.UNIX
  elseif vim.fn.has('win32') == 1 then
    return icons.WINDOWS
  end
end

local feline_config = {
  properties = {
    force_inactive = {
      filetypes = {
        'NvimTree',
        'packer',
        'startify',
        'fugitive',
        'fugitiveblame',
        'qf',
        'help',
        'coc-explorer'
      },
      buftypes = { 'terminal' },
      bufnames = {}
    }
  },
  components = {
    left = {
      active = {
        { provider = '▊ ', hl = { fg = 'skyblue' } },
        {
          provider = 'vi_mode',
          hl = function()
            local val = {}

            val.name = vi_mode_utils.get_mode_highlight_name()
            val.fg = vi_mode_utils.get_mode_color()
            val.style = 'bold'

            return val
          end,
          right_sep = ' '
        },
        {
          provider = 'file_info',
          hl = { fg = 'white', bg = 'oceanblue', style = 'bold' },
          left_sep = { 'block', { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } } },
          right_sep = { 'block' }
        },
        {
          provider = 'git_branch',
          hl = { fg = 'black', bg = 'green', style = 'bold' },
          enabled = function() return b.gitsigns_status_dict ~= nil end,
          left_sep = { { str = 'block', hl = { fg = 'green' } } },
          right_sep = { { str = 'block', hl = { fg = 'green' } } }
        },
        { provider = 'git_diff_added', hl = { fg = 'green', bg = 'black' } },
        { provider = 'git_diff_changed', hl = { fg = 'orange', bg = 'black' } },
        {
          provider = 'git_diff_removed',
          hl = { fg = 'red', bg = 'black' },
          right_sep = function()
            local val = { hl = { fg = 'NONE', bg = 'black' } }
            if b.gitsigns_status_dict then
              val.str = ' '
            else
              val.str = ''
            end

            return val
          end
        },
        {
          provider = 'diagnostic_errors',
          enabled = function() return lsp.diagnostics_exist('Error') end,
          hl = { fg = 'red' }
        },
        {
          provider = 'diagnostic_warnings',
          enabled = function() return lsp.diagnostics_exist('Warning') end,
          hl = { fg = 'yellow' }
        },
        {
          provider = 'diagnostic_hints',
          enabled = function() return lsp.diagnostics_exist('Hint') end,
          hl = { fg = 'cyan' }
        },
        {
          provider = 'diagnostic_info',
          enabled = function() return lsp.diagnostics_exist('Information') end,
          hl = { fg = 'skyblue' }
        },
        { provider = ' ', hl = { fg = 'yellow' } },
        { provider = function() return vim.api.nvim_eval('coc#status()') end }
      },
      inactive = {
        {
          provider = 'file_type',
          hl = { fg = 'white', bg = 'oceanblue', style = 'bold' },
          left_sep = { str = ' ', hl = { fg = 'NONE', bg = 'oceanblue' } },
          right_sep = { { str = ' ', hl = { fg = 'NONE', bg = 'oceanblue' } }, 'slant_right' }
        }
      }
    },
    mid = { active = {}, inactive = {} },
    right = {
      active = {
        {
          provider = 'file_type',
          hl = { fg = 'cyan', bg = 'NONE', style = 'bold,italic' },
          left_sep = { 'slant_left_thin', ' ' },
          right_sep = { ' ', 'slant_right_thin' }
        },
        { provider = OsIcon(), left_sep = { ' ' } },
        { provider = 'file_encoding', left_sep = { ' ' }, right_sep = { ' ' } },
        {
          provider = 'position',
          left_sep = { 'slant_left_thin', ' ' },
          right_sep = { ' ', { str = 'slant_right_thin' } }
        },
        {
          provider = 'file_size',
          enabled = function() return fn.getfsize(fn.expand('%:p')) > 0 end,
          left_sep = { ' ' },
          right_sep = { ' ', { str = 'slant_right_2_thin' } }
        },
        {
          provider = 'line_percentage',
          hl = { fg = 'orange', style = 'bold' },
          left_sep = '  ',
          right_sep = ' '
        },
        { provider = 'scroll_bar', hl = { fg = 'skyblue', style = 'bold' } }
      },
      inactive = {}
    }
  }
}

require('feline').setup(feline_config)
