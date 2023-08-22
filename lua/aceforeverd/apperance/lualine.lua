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

local M = {}

local palette = require('aceforeverd.apperance.helper')
local bit_green = palette.bit_green
local bit_blue = palette.bit_blue
local bit_yellow = palette.bit_yellow
local bit_red = palette.bit_red
local orange = palette.orange

local function gen_winbar_cfg()
  if vim.fn.exists('+winbar') ~= 0 then
    return {
      lualine_a = {
        {
          'filename',
          path = 1, --[[ relative path ]]
        },
      },
      lualine_b = {
        {
          require('aceforeverd.utility.statusline').ctx_location,
          on_click = function(num_click, mounse, modifiers)
            require('nvim-navbuddy').open()
          end,
          color = { fg = orange },
        },
      },
      lualine_z = { 'datetime' },
    }
  end

  return {}
end

function M.setup()
  require('lualine').setup({
    options = {
      theme = 'palenight',
      global_status = true,
      section_separators = { left = '', right = '' },
      component_separators = { left = '|', right = '|' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        {
          'diff',
          source = function()
            local s = vim.b.gitsigns_status_dict
            if s == nil then
              return nil
            end

            return { added = s.added, modified = s.changed, removed = s.removed }
          end,
        },
        'diagnostics',
      },
      lualine_c = {
        { require('aceforeverd.utility.statusline').lsp_client_names, icon = { ' ' }, color = { fg = '#FF9000' } },
        {
          require('aceforeverd.utility.statusline').lsp_status,
          color = { fg = '#E1E120' },
        },
      },
      lualine_x = {
        {
          require('aceforeverd.utility.statusline').ctx_location,
          cond = function()
            -- otherwise it will appear in winbar
            return vim.fn.exists('+winbar') == 0
          end,
          color = { fg = '#fda5b4' },
        },
        { require('aceforeverd.utility.statusline').tag_status },
        'filetype',
        { require('aceforeverd.utility.statusline').indent },
        {
          'vim.bo.spelllang',
          cond = function()
            return vim.wo.spell == true
          end,
        },
        'encoding',
      },
      lualine_y = { 'fileformat', 'location' },
      lualine_z = { 'filesize', 'progress' },
    },
    winbar = gen_winbar_cfg(),
    extensions = { 'quickfix', 'fugitive', 'lazy', 'fzf' },
  })
end

return M
