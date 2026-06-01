-- 删除plugin 
--  1. 注释/删除下面的require
--  2. 在vim中输入如 `:lua vim.pack.del({ 'nvim-lspconfig', 'nvim-treesitter' })` （插件具体名称可以看文件 `nvim-pack-lock.json`）

-------------------------------------------------------------------------------
-- 文件树
-------------------------------------------------------------------------------

-- nvim-tree.lua
require("plugin.nvim-tree")

-------------------------------------------------------------------------------
-- 缩进竖线
-------------------------------------------------------------------------------

-- indent-blankline.nvim
-- require("plugin.indent-blankline")

-- hlchunk.nvim
-- require("plugin.hlchunk")

-------------------------------------------------------------------------------
-- git
-------------------------------------------------------------------------------

-- gitsigns.nvim
require("plugin.gitsigns")

-- vim-fugitive
require("plugin.fugitive")

-------------------------------------------------------------------------------
-- 查找
-------------------------------------------------------------------------------

-- telescope.nvim
require("plugin.telescope")

-------------------------------------------------------------------------------
-- theme
-------------------------------------------------------------------------------

-- vscode.nvim
require("plugin.vscode-theme")

-- tokyonight.
--require("plugin.tokyonight-theme")

-------------------------------------------------------------------------------
-- 状态栏
-------------------------------------------------------------------------------

-- lualine.nvim
-- 只使用底部
require("plugin.lualine")

-- bufferline.nvim
-- 顶部buffer
require("plugin.bufferline")

-------------------------------------------------------------------------------
-- 编辑
-------------------------------------------------------------------------------

-- 多光标
-- multiple-cursors.nvim
require("plugin.multiple-cursors")

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------

-- nvim-lspconfig
require("plugin.nvim-lspconfig")

-- mason
require("plugin.mason")

-- 悬停
-- eagle.nvim
require("plugin.eagle")

-- 补全
-- blink.cmp
require("plugin.blink_cmp")

-------------------------------------------------------------------------------
-- Markdown
-------------------------------------------------------------------------------

-- markdown 渲染
-- markview.nvim
require("plugin.markview")

-- markdown 支持
-- markdown-plus.nvim
-- require("plugin.markdown-plus")
-- mkdnflow.nvim
require("plugin.mkdnflow")
