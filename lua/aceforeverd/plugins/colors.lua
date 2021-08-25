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
local catppuccino = require("catppuccino")
local catppuccino_scheme = require('catppuccino.color_schemes.catppuccino')
catppuccino_scheme.diff = {
  add = "#C3E88D",
  change = "#F6A878",
  delete = "#e06c75",
  text = '#B0BEC5'
}
catppuccino_scheme.git = {
  add = "#C3E88D",
  change = "#F6A878",
  delete = "#e06c75",
  conflict = "#FFE37E"
}
catppuccino_scheme.bg = '#212121'
-- configure it
catppuccino.setup({
  colorscheme = "catppuccino",
  transparency = false,
  styles = {
    comments = "italic",
    functions = "NONE",
    keywords = "italic",
    strings = "NONE",
    variables = "NONE"
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      styles = {
        errors = "italic,bold",
        hints = "italic",
        warnings = "italic",
        information = "italic"
      }
    },
    lsp_trouble = false,
    lsp_saga = false,
    gitgutter = false,
    gitsigns = true,
    telescope = true,
    nvimtree = true,
    which_key = true,
    indent_blankline = false,
    dashboard = false,
    neogit = true,
    vim_sneak = true,
    fern = false,
    barbar = false,
    bufferline = true,
    markdown = false
  }
}, catppuccino_scheme)

if vim.fn.has('nvim-0.6.0') == 1 then
  catppuccino.load()
  vim.api.nvim_exec(
    [[
    highlight Conceal ctermfg=Grey guifg=#565656
    augroup catppuccino_coc
        autocmd!
        autocmd ColorScheme * highlight Conceal ctermfg=Grey guifg=#565656
    augroup END]], false)
else
  vim.g.material_style = 'darker'
  vim.g.material_borders = true
  vim.g.material_variable_color = '#3adbc5'
  vim.g.material_italic_keywords = true
  vim.g.material_italic_comments = true
  vim.api.nvim_set_keymap('n', [[<space>n]],
                          [[<Cmd>lua require('material.functions').toggle_style()<CR>]],
                          { noremap = true, silent = true })
  require('material').set()
end
