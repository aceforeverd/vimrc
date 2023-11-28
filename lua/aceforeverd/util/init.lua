local M = {}

local getparent = function(p)
  return vim.fn.fnamemodify(p, ':h')
end
local function find_root(markers, dirname)
  while getparent(dirname) ~= dirname do
    for _, marker in ipairs(markers) do
      if vim.loop.fs_stat(dirname .. '/' .. marker) then
        return dirname
      end
    end
    dirname = getparent(dirname)
  end
end


--- file pattern based root directory detection with priority
---@param patterns table<table<string>>  Two-dimensional array for detect file pattern
function M.detect_root(patterns)
  local bufname =  vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local dirname = vim.fn.fnamemodify(bufname, ':p:h')
  for _, list in ipairs(patterns) do
    local root_path = find_root(list, dirname)
    if root_path ~= nil then
      return root_path
    end
  end
end


return M
