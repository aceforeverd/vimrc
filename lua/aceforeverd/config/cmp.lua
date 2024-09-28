local M = {}

function M.setup()
  if vim.g.my_cmp_source ~= 'nvim_lsp' then
    return
  end

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local tab_map = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end

  local s_tab_map = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end

  local i_ctrl_j = function(fallback)
    if luasnip.expand_or_jumpable() then
      feedkey('<Plug>luasnip-expand-or-jump', '')
    else
      fallback()
    end
  end

  local i_ctrl_k = function(fallback)
    if luasnip.jumpable(-1) then
      feedkey('<Plug>luasnip-jump-prev', '')
    else
      fallback()
    end
  end

  -- cancel any selection and perform i_ctlr-h
  local i_ctrl_h = function(fallback)
    if cmp.visible() then
      cmp.abort()
    end
    fallback()
  end

  local lspkind = require('lspkind')

  -- level 1 source
  local sources_1 = {
    { name = "lazydev" },
    { name = 'nvim_lsp' },
    { name = 'luasnip', option = { use_show_condition = false } },

    { name = 'path' },

    { name = 'git' },
    { name = 'treesitter', keyword_length = 3 },
    {
      name = 'buffer',
      option = {
        indexing_interval = 100,
        get_bufnrs = function()
          -- only the visible buffer
          local bufs = {}
          local cur_buf = vim.api.nvim_get_current_buf()
          local byte_size = vim.api.nvim_buf_get_offset(cur_buf, vim.api.nvim_buf_line_count(cur_buf))
          if byte_size > 256 * 1024 or vim.fn.line('$') > 1000 then
            -- stop on files larger than 256k or line number > 1000
            return {}
          end

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = 'emoji' },
    { name = 'tmux', keyword_length = 3, max_item_count = 10 },
    { name = "crates" },
  }

  cmp.setup({
    preselect = cmp.PreselectMode.None,
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
      ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ['<C-h>'] = cmp.mapping({ i = i_ctrl_h, c = cmp.mapping.close() }),
      ['<C-j>'] = cmp.mapping(i_ctrl_j, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(i_ctrl_k, { 'i', 's' }),
      -- TODO: CR show jump after select inside jump
      ['<CR>'] = cmp.mapping({
        i = cmp.mapping.confirm({ select = false }),
        c = cmp.mapping.confirm({ select = false }),
      }),
      ['<C-space>'] = cmp.mapping(cmp.complete),
    },
    sources = cmp.config.sources(sources_1),
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
        menu = {
          nvim_lsp = '[LSP]',
          lazydev = '[LazyDev]',
          luasnip = '[LuaSnip]',
          buffer = '[Buffer]',
          path = '[Path]',
          look = '[Look]',
          emoji = '[Emoji]',
          treesitter = '[TreeSitter]',
          tmux = '[Tmux]',
          git = '[Git]',
          crates = '[Crates]',
        },
      }),
    },

    -- add sorting rules
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        require('clangd_extensions.cmp_scores'),
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  })
end

return M
