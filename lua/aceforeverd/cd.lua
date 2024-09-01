--- Set directory for curent buffer. By LSPs firstly, if non available, use fallback function
--- @param fallback {fn: function, hint: string} Fallback function info returns root directory as string
local function find_root(fallback)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  local dirs = vim
    .iter(clients)
    :filter(function(client)
      local filetypes = client.config.filetypes
      if filetypes and vim.tbl_contains(filetypes, ft) then
        return true
      end

      return false
    end)
    :map(function(client)
      return { root = client.config.root_dir, client = client.name }
    end)
    :totable()

  if type(fallback) == 'table' then
    local dir = fallback.fn()
    if dir ~= nil and dir ~= '' then
      table.insert(dirs, { root = dir, client = fallback.hint })
    end
  end

  if #dirs == 0 then
    vim.notify('no rule to cd')
    return
  end

  local verbose_status = vim.trim(vim.fn.execute('verbose pwd'))

  vim.ui.select(dirs, {
    prompt = 'SELECT ROOT. ' .. verbose_status,
    format_item = function(info)
      return string.format('%s [%s]', info.root, info.client)
    end,
  }, function(choice)
    if choice ~= nil then
      if vim.fn.getcwd() ~= choice.root then
        vim.notify('setting root to ' .. choice.root, vim.log.levels.INFO, {})
        vim.fn.chdir(choice.root)
      else
        vim.notify('root already in ' .. choice.root, vim.log.levels.INFO, {})
      end
    end
  end)
end

return {
  find_root = find_root,
}
