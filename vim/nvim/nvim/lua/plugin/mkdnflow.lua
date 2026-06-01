vim.pack.add({
  "https://github.com/jakewvincent/mkdnflow.nvim",
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = "markdown",
  callback = function()
    require("mkdnflow").setup({
      mappings = {
        MkdnFollowLink = { 'n', '<leader>ml' },
      }
    })
  end
})
