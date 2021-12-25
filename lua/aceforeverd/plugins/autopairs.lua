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

function M.pre_hook()
-- to be done
end

function M.setup()
  local npairs = require('nvim-autopairs')
  npairs.setup()

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done({}))

  cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"

  -- add some endwise rules
  -- NOTE: vim-endwise will break on neovim with nvim-treesitter highlight feature enabled
  --   see https://github.com/nvim-treesitter/nvim-treesitter/issues/703
  -- npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
  -- npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
  -- npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
end

return M
