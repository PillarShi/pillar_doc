vim.pack.add({
  { src = "https://github.com/shellRaining/hlchunk.nvim", name = "hlchunk"}
})

require("hlchunk").setup({
  chunk = {
    enable = true,
    chars = {
      horizontal_line = "",
      vertical_line = "│",
      left_top = "",
      left_bottom = "",
      right_arrow = "",
    },
    -- 颜色
    style = "#bababa",
    -- 动画相关
    duration = 200,
    delay = 0, -- 关闭
  },

  indent = {
    enable = true
  },

  line_num = {
    enable = false
  },

  blank = {
    enable = false
  }
})
