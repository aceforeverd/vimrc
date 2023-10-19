-- Copyright (C) 2022  Ace <teapot@aceforeverd.com>
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

-- enhancement for an nvim variant feature

local M = {}

local function map_c_n()
  if require('yanky').can_cycle() then
    require('yanky').cycle(1)
  else
    vim.cmd([[execute "normal! \<c-n>"]])
  end
end

local function map_c_p()
  if require('yanky').can_cycle() then
    require('yanky').cycle(-1)
  else
    vim.cmd([[FZF --info=inline]])
  end
end

function M.yanky()
  require('yanky').setup({
    ring = {
      cancel_event = 'move',
    },
  })
  require('aceforeverd.util.map').do_map({
    n = {
      p = [[<Plug>(YankyPutAfter)]],
      P = [[<Plug>(YankyPutBefore)]],
      gp = [[<Plug>(YankyGPutAfter)]],
      gP = [[<Plug>(YankyGPutBefore)]],
      ['<c-n>'] = map_c_n,
      ['<c-p>'] = map_c_p,
    },
    x = {
      p = [[<Plug>(YankyPutAfter)]],
      P = [[<Plug>(YankyPutBefore)]],
      gp = [[<Plug>(YankyGPutAfter)]],
      gP = [[<Plug>(YankyGPutBefore)]],
    },
  }, {})
end

function M.substitute()
  require('substitute').setup({
    on_substitute = function(event)
      require('yanky.integration').substitute()
    end,
    yank_substituted_text = true,
  })
  require('aceforeverd.util.map').do_map({
    n = {
      ['<leader>s'] = [[<cmd>lua require('substitute').operator()<cr>]],
      ['<leader>ss'] = [[<cmd>lua require('substitute').line()<cr>]],
      ['<leader>S'] = [[<cmd>lua require('substitute').eol()<cr>]],
    },
    x = {
      ['<leader>s'] = [[<cmd>lua require('substitute').visual()<cr>]],
    },
  }, { nnoremap = true })
end

function M.toggle_term()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
    float_opts = {
      border = 'curved',
      winblend = 10,
    },
  })

  function Lazygit()
    lazygit:toggle()
  end

  require('toggleterm').setup({
    open_mapping = [[<C-\><C-\>]],
    direction = 'float',
    float_opts = {
      border = 'curved',
      winblend = 10,
    },
  })
  require('aceforeverd.util.map').do_mode_map('n', '', {
    ['<leader>tx'] = [[<cmd>execute v:count . "ToggleTerm direction=horizontal"<cr>]],
    ['<leader>tv'] = [[<cmd>execute v:count . "ToggleTerm direction=vertical"<cr>]],
    ['<leader>tf'] = [[<cmd>execute v:count . "ToggleTerm direction=float"<cr>]],
    ['<leader>tt'] = [[<cmd>execute v:count . "ToggleTerm direction=tab"<cr>]],
    ['<leader>gl'] = [[<cmd>lua Lazygit()<CR>]],
  }, {})
end

function M.autopairs()
  local npairs = require('nvim-autopairs')
  npairs.setup()

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done({}))

  -- add some endwise rules
  -- NOTE: vim-endwise will break on neovim with nvim-treesitter highlight feature enabled
  --   see https://github.com/nvim-treesitter/nvim-treesitter/issues/703
  -- npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
  -- npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
  -- npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
end

function M.indent_blankline()
  -- set list
  vim.opt.list = true
  vim.opt.listchars:append('space:⋅')

  local highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  }
  local hooks = require('ibl.hooks')
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#E06C75' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#E5C07B' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#61AFEF' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#D19A66' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#98C379' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#C678DD' })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = '#56B6C2' })
  end)

  require('ibl').setup({
    indent = {
      char = '▎',
      tab_char = '┊',
    },
    scope = { highlight = highlight },
    exclude = {
      filetypes = {
        'startify',
        'coc-explorer',
        'NvimTree',
        'help',
        'git',
        'mason',
        'OverseerForm',
        'alpha',
      },
    },
  })

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
