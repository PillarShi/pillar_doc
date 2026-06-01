-- See https://neovim.io/doc/user/pack/#vim.pack-events
-- and https://www.reddit.com/r/neovim/comments/1pzwnls/vimpack_with_telescopefzfnative_how/
local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
    vim.print(ev.data.path)
    vim.system({ "make" }, { cwd = ev.data.path }):wait()
  end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
})

require("telescope").setup({
  defaults = {
    path_display = { "smart" },
  },
  extensions = {
    fzf = {},
  },
})

-- set keymaps
local builtin = require("telescope.builtin")
-- 查找文件
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
-- 当前文件内容查找
vim.keymap.set("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "Telescope file fuzzy finder" })
-- 需要额外扩展 ripgrep
-- vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep" })
-- vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Telescope grep string' })
