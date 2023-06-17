local palette = vim.api.nvim_call_function('sonokai#get_palette', { vim.g.sonokai_style, { nothing = '' } })

return {
 bit_green = palette.bg_green[1],
 bit_blue = palette.bg_blue[1],
 bit_yellow = palette.yellow[0] or '#e5c463',
 bit_red = palette.bg_red[1],
  orange = palette.orange[1],
}
