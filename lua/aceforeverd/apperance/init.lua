local M = {}

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

function M.ufo()
    require('ufo').setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end,
    })
end

local set_map = vim.api.nvim_set_keymap
local map_opt = { noremap = false, silent = true }

function M.bufferline()
  require('bufferline').setup({
    options = {
      numbers = function(opts)
        return string.format('%s|%s.)', opts.id, opts.raise(opts.ordinal))
      end,
      always_show_bufferline = true,
      diagnostics = vim.g.my_cmp_source,
      separator_style = 'slant',
    },
  })

  set_map('n', '<M-.>', '<Cmd>BufferLineCycleNext<CR>', map_opt)
  set_map('n', '<M-,>', '<Cmd>BufferLineCyclePrev<CR>', map_opt)
  -- override unimpaired mappings
  set_map('n', ']b', '<Cmd>BufferLineCycleNext<CR>', map_opt)
  set_map('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', map_opt)

  set_map('n', '<M-<>', '<Cmd>BufferLineMovePrev<CR>', map_opt)
  set_map('n', '<M->>', '<Cmd>BufferLineMoveNext<CR>', map_opt)

  set_map('n', '<M-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', map_opt)
  set_map('n', '<M-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', map_opt)
  set_map('n', '<M-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', map_opt)
  set_map('n', '<M-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', map_opt)
  set_map('n', '<M-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', map_opt)
  set_map('n', '<M-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', map_opt)
  set_map('n', '<M-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', map_opt)
  set_map('n', '<M-7>', '<Cmd>BufferLineGoToBuffer 8<CR>', map_opt)
  set_map('n', '<M-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', map_opt)
end

return M
