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

function M.setup()
  if vim.g.lsp_process_provider == nil then
    vim.g.lsp_process_provider = 'lsp_status'
  end

  require('aceforeverd.utility.map').do_map({
    n = {
      ['}}'] = '}',
      ['{{'] = '{',
    }
  }, { nnoremap = true, silent = true })

  vim.o.foldcolumn = '1' -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  vim.o.fillchars = [[foldopen:▼,foldclose:⏵]]
  vim.o.exrc = true -- automatically execute project local configs

  require('aceforeverd.plugins').setup()

  -- keymap guideline
  -- <space>xxx   -> view-only operators
  -- <leader>xxx  -> possibly write operators
end

return M
