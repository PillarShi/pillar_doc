vim.pack.add({
  "https://github.com/YousefHadder/markdown-plus.nvim",
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = "markdown",
  callback = function()
    require("markdown-plus").setup()
  end
})
