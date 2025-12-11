local default = {
  bg_yellow = { '#4e432f', 94 },
  green = { '#9ed06c', 107 },
  bg_blue = { '#354157', 17 },
  yellow = { '#edc763', 179 },
  filled_blue = { '#77d5f0', 110 },
  grey_dim = { '#5a5e7a', 240 },
  none = { nil, nil },
  grey = { '#7e8294', 246 },
  filled_red = { '#ff6188', 203 },
  fg = { '#e1e3e4', 250 },
  purple = { '#bb97ee', 176 },
  bg_dim = { '#252630', 232 },
  bg_red = { '#55393d', 52 },
  bg_purple = { '#423f59', 54 },
  bg0 = { '#2b2d3a', 235 },
  bg1 = { '#333648', 236 },
  bg2 = { '#363a4e', 236 },
  bg3 = { '#393e53', 237 },
  bg4 = { '#3f445b', 237 },
  filled_green = { '#a9dc76', 107 },
  orange = { '#f89860', 215 },
  black = { '#181a1c', 232 },
  blue = { '#6dcae8', 110 },
  bg_green = { '#394634', 22 },
  red = { '#fb617e', 203 },
}
local palette = default
if vim.g.colors_name == 'sonokai' then
  palette = vim.api.nvim_call_function('sonokai#get_palette', { vim.g.sonokai_style, { nothing = '' } })
end

return {
  bit_green = palette.bg_green[1],
  bit_blue = palette.bg_blue[1],
  bit_yellow = palette.yellow[0] or '#e5c463',
  bit_red = palette.bg_red[1],
  orange = palette.orange[1],
}
