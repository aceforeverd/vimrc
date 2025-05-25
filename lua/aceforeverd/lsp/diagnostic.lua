local M = {}

local severity_emoji_map = {
  [vim.diagnostic.severity.ERROR] = '😡',
  [vim.diagnostic.severity.WARN] = '😨',
  [vim.diagnostic.severity.INFO] = '😟',
  [vim.diagnostic.severity.HINT] = '🤔',
}

local fmt_fn = function(diagnostic)
  local mes = diagnostic.message

  if diagnostic.code ~= nil then
    mes = mes .. string.format(' [%s]', diagnostic.code)
  end

  -- if diagnostic.user_data then
  --   mes = mes .. string.format(' (%s)', vim.inspect(diagnostic.user_data))
  -- end

  return mes
end
local suffix_fn = function(diagnostic)
  return severity_emoji_map[diagnostic.severity]
end

M.diag_config = {
  underline = true,
  update_in_insert = false,
  virtual_lines = false, -- virtual text & float is enough
  virtual_text = {
    prefix = '🤡', -- Could be '●', '▎', 'x'
    suffix = suffix_fn,
    source = 'always',
    format = fmt_fn,
  },
  severity_sort = true,
  float = {
    suffix = suffix_fn,
    source = 'always',
    severity_sort = true,
    format = fmt_fn,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '󰛩 ',
      [vim.diagnostic.severity.INFO] = '',
    },
    -- linehl = {
    --   [vim.diagnostic.severity.ERROR] = 'LspDiagnosticsSignError',
    --   [vim.diagnostic.severity.WARN] = 'LspDiagnosticsSignWarning',
    --   [vim.diagnostic.severity.HINT] = 'LspDiagnosticsSignHint',
    --   [vim.diagnostic.severity.INFO] = 'LspDiagnosticsSignInformation',
    -- },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'LspDiagnosticsSignError',
      [vim.diagnostic.severity.WARN] = 'LspDiagnosticsSignWarning',
      [vim.diagnostic.severity.HINT] = 'LspDiagnosticsSignHint',
      [vim.diagnostic.severity.INFO] = 'LspDiagnosticsSignInformation',
    },
  },
}

M.diagnostics_config = function()
  vim.diagnostic.config(M.diag_config)
end

return M
