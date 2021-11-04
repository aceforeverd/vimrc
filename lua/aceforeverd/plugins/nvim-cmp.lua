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

if vim.fn.has('nvim-0.6.0') == 0 then
    return
end

local default_map_opts = { noremap = true, silent = true }

local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping(
        { i = cmp.mapping.confirm({ select = false }), c = cmp.mapping.confirm({ select = false }) })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'look', keyword_length = 2, default_map_opts = { convert_case = true, loud = true } },
    { name = 'emoji' },
    { name = 'treesitter' },
    { name = 'tmux' },
    { name = 'spell' },
    { name = 'tag' },
    { name = 'cmdline' }
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      menu = {
        nvim_lsp = "[LSP]",
        vsnip = "[Vsnip]",
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lua = "[Lua]",
        look = "[Look]",
        emoji = "[Emoji]",
        treesitter = "[TreeSitter]",
        tmux = "[Tmux]",
        luasnip = "[LuaSnip]",
        latex_symbols = "[Latex]",
        spell = '[Spell]',
        tag = '[Tag]',
        cmdline = '[Cmdline]',
        nvim_lsp_document_symbol = '[DocumentSymbol]'
      }
    })
  }
})

cmp.setup.cmdline('/', {
  sources = cmp.config.sources({ { name = 'nvim_lsp_document_symbol' } },
                               { { name = 'buffer', keyword_length = 5 } })
})
cmp.setup.cmdline('?', {
  sources = cmp.config.sources({ { name = 'nvim_lsp_document_symbol' } },
                               { { name = 'buffer', keyword_length = 5 } })
})

cmp.setup.cmdline(':', { sources = cmp.config.sources({ { name = 'path' } }) })

-- vsnip
vim.api.nvim_set_keymap('i', '<c-j>',
                        "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'",
                        { expr = true })
vim.api.nvim_set_keymap('s', '<c-j>',
                        "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'",
                        { expr = true })

vim.api.nvim_set_keymap('n', 's', '<Plug>(vsnip-select-text)', default_map_opts)
vim.api.nvim_set_keymap('x', 's', '<Plug>(vsnip-select-text)', default_map_opts)
vim.api.nvim_set_keymap('n', 'S', '<Plug>(vsnip-cut-text)', default_map_opts)
vim.api.nvim_set_keymap('x', 'S', '<Plug>(vsnip-cut-text)', default_map_opts)
