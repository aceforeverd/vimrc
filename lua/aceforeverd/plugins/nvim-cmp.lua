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
if vim.g.my_cmp_source ~= 'nvim_lsp' then
  return
end

vim.g.UltiSnipsRemoveSelectModeMappings = 0

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')
local luasnip = require('luasnip')

local tab_map = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    feedkey('<Plug>luasnip-expand-or-jump', '')
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end
local s_tab_map = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    feedkey('<Plug>luasnip-jump-prev', '')
  else
    fallback()
  end
end

local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

    ['<Tab>'] = cmp.mapping(tab_map, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(s_tab_map, { 'i', 's' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping({ i = cmp.mapping.confirm({ select = false }), c = cmp.mapping.confirm({ select = false }) }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip', opts = { use_show_condition = false } },
    { name = 'ultisnips' },
    { name = 'vsnip' },

    { name = 'nvim_lua' },
    {
      name = 'buffer',
      get_bufnrs = function()
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          bufs[vim.api.nvim_win_get_buf(win)] = true
        end
        return vim.tbl_keys(bufs)
      end,
    },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'emoji' },
    { name = 'calc' },
    { name = 'spell' },
    { name = 'tmux', keyword_length = 3, max_item_count = 5 },
    { name = 'look', keyword_length = 2, max_item_count = 8, default_map_opts = { convert_case = true, loud = true } },
    { name = 'cmdline' },
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      menu = {
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        ultisnips = '[UltiSnips]',
        vsnip = "[Vsnip]",
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lua = "[Lua]",
        look = "[Look]",
        emoji = "[Emoji]",
        treesitter = "[TreeSitter]",
        calc = '[Calc]',
        tmux = "[Tmux]",
        spell = '[Spell]',
        cmdline = '[Cmdline]',
      },
    }),
  },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- vsnip
vim.api.nvim_set_keymap('i', '<c-j>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'", { expr = true })
vim.api.nvim_set_keymap('s', '<c-j>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'", { expr = true })
vim.api.nvim_set_keymap('i', '<c-k>', "vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-k>'", { expr = true })
vim.api.nvim_set_keymap('s', '<c-k>', "vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-k>'", { expr = true })
