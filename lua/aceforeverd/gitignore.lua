local M = {}

local endpoint = 'https://www.toptal.com/developers/gitignore/api/'

function M.gitignore_selects(opts)
  -- Example: Using Telescope directly for multi-select
  require('telescope.pickers')
    .new({}, {
      prompt_title = 'GitIgnore Generator:',
      finder = require('telescope.finders').new_table({
        results = { 'Item A', 'Item B', 'Item C' , 'c', 'c++'},
      }),
      sorter = require('telescope.config').values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local selections = picker:get_multi_selection()

          -- Fallback if user hit enter without tabbing anything
          if vim.tbl_isempty(selections) then
            table.insert(selections, action_state.get_selected_entry())
          end

          actions.close(prompt_bufnr)
          M.gitignore({
            lang = vim.tbl_map(function(val)
              return val[1]
            end, selections),
          })
        end)
        return true
      end,
    })
    :find()
end

--- generate gitignore file to >> .gitignore
---@param opts {lang:[string] | string, fargs?: [string]}
function M.gitignore(opts)
  opts = opts or {}
  local lang = opts.lang or opts.fargs

  if type(lang) == 'table' then
    lang = table.concat(lang, ',')
  end
  local curl = require('plenary.curl')
  curl
    .get(endpoint .. lang, {
      callback = function(res)
        local output_path = '.gitignore'
        if res.status == 200 then
          local file = io.open(output_path, 'a+')
          if file then
            file:write(res.body)
            file:close()

            -- Use schedule to send a notification back to the Neovim UI thread
            vim.schedule(function()
              print('Async saved ignore content to: ' .. output_path)
            end)
          end
        else
          vim.schedule(function()
            vim.notify(vim.inspect(res), vim.log.levels.WARN, {})
          end)
        end
      end,
    })
    :sync()
end

return M
