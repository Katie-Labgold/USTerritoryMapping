# https://nanx.me/blog/post/rebranding-r-packages-with-hexagon-stickers/

library(hexSticker)

hexSticker::sticker(
  subplot = ~ plot.new(), s_x = 1, s_y = 1, s_width = 0.1, s_height = 0.1,
  package = "USTerritoryMapping", p_x = 1, p_y = 1, p_size = 14, h_size = 1.2, p_family = "pf",
  p_color = "#7DBC8E", h_fill = "#FFF9F2", h_color = "#F3BA42",
  dpi = 320, filename = "man/figures/logo.png"
)
