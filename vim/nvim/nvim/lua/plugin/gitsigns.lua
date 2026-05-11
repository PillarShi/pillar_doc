vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns" }
})

require("gitsigns").setup({
  -- 开启行责任人显示
  current_line_blame = true,
  -- 自定义显示样式和内容
  current_line_blame_opts = {
    virt_text = true,
    -- 显示位置为行尾，也可以设置为 'right_align'
    virt_text_pos = 'eol',
    -- 光标停留多久(毫秒)后显示，通常不用太长
    delay = 100,
  },
})
