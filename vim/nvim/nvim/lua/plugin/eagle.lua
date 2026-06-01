vim.pack.add({
  "https://github.com/soulis-1256/eagle.nvim"
})

vim.o.mousemoveevent = true

require("eagle").setup({
  -- 鼠标悬停后，等待多久(毫秒)弹出窗口，默认500
  render_delay = 300,
  -- 窗口外观
  border = "rounded",   -- 窗口边框风格: "single", "double", "rounded" 等
  -- max_width_factor = 1.5, -- 窗口最大宽度，相对于编辑器宽度的比例
  -- max_height_factor = 2,  -- 窗口最大高度，相对于编辑器高度的比例
})
