vim.pack.add({
  { src = "https://github.com/brenton-leighton/multiple-cursors.nvim", name = "multiple-cursors"}
})

require("multiple-cursors").setup()

vim.keymap.set({"n", "x"}, "<C-J>",  "<Cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor and move down" })
vim.keymap.set({"n", "x"}, "<C-K>",  "<Cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor and move up" })
