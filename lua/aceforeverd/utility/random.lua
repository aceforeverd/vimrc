local M = {}

function M.random(n, m)
  math.randomseed(os.time())
  return math.random(n, m)
end

return M
