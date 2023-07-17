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

-- general status line component provider

local M = {}

local _get_active_client = function() return vim.lsp.buf_get_clients(0) end
if vim.fn.has('nvim-0.8.0') == 1 then
  _get_active_client = function ()
    return vim.lsp.get_active_clients({ bufnr = 0 })
  end
end

function M.indent()
  return 'IN:' .. tostring(vim.fn.indent(vim.fn.line('.'))) .. '/' .. tostring(vim.o.shiftwidth)
end

function M.file_size()
  -- credit: feline.nvim
  local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
  local index = 1

  local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))

  if fsize < 0 then
    fsize = 0
  end

  while fsize > 1024 and index < 7 do
    fsize = fsize / 1024
    index = index + 1
  end

  return string.format(index == 1 and '%g%s' or '%.2f%s', fsize, suffix[index])
end

local E = vim.diagnostic.severity.ERROR
local W = vim.diagnostic.severity.WARN
local I = vim.diagnostic.severity.INFO
local H = vim.diagnostic.severity.HINT
local severity_symbols = {
  [E] = ' ',
  [W] = ' ',
  [I] = '',
  [H] = '',
}

local function diagnostic(severity)
  local cnt = vim.tbl_count(vim.diagnostic.get(0, { severity = severity }))
  if cnt ~= 0 then
    return string.format('%s%d ', severity_symbols[severity], cnt)
  else
    return ''
  end
end

function M.lsp_diagnostic()
  return string.format('%s%s%s%s', diagnostic(E), diagnostic(W), diagnostic(I), diagnostic(H))
end

function M.lsp_client_names()
  local clients = {}

  for _, client in pairs(_get_active_client()) do
      table.insert(clients, client.name)
  end

  return table.concat(clients, ','), ' '
end


local fmt_status = function(symbols, separator)
  local parts = {}

  for _, symbol in ipairs(symbols) do
    table.insert(parts, string.format('%s  %s', symbol.icon, symbol.name))
  end

  return table.concat(parts, separator)
end

-- use navic and aerial to get context location
function M.ctx_location(opts)
  opts = opts or {}

  local s0, navic = pcall(require, 'nvim-navic')
  if s0 and navic.is_available() then
    local r = navic.get_location()
    if r ~= '' then
      return r
    end
  end

  local s1, aerial = pcall(require, 'aerial')
  if s1 then
    local r = aerial.get_location() or {}
    if r ~= {} then
      return fmt_status(r, ' > ')
    end
  end

  local size = 40
  if opts.short then
    size = 10
  end
  local text = require('nvim-treesitter').statusline({ indicator_size = size })
  if text then
    return text
  else
    return ''
  end
end

local lsp_status
if vim.g.lsp_process_provider == 'lsp_progress' then
  lsp_status = function()
    return require('lsp-progress').progress()
  end
elseif vim.g.lsp_process_provider == 'lsp_status' then
  lsp_status = function()
    return require('lsp-status').status()
  end
end

M.lsp_status = lsp_status

return M
