-- windows下需要有支持 Nerd Font 的字体才能有图标
-- 可以下载安装字体 ttf/CascadiaMonoNF.ttf（https://github.com/microsoft/cascadia-code/releases）
vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- 可选，更加完整漂亮的图标
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

-- 用 netrw，避免与 nvim-tree 冲突
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 启用真彩色支持
vim.opt.termguicolors = true

-- 下面内容由AI生成，需要注意
require("nvim-tree").setup({

  -- ========== 窗口外观配置 ==========
  view = {
    -- 文件树面板宽度（字符数）
    -- 可根据屏幕大小和个人喜好调整，常见范围 25-40
    width = 35,

    -- 是否显示相对行号
    -- false: 不显示行号，界面更简洁
    -- true:  显示相对行号，方便用行号跳转
    relativenumber = false,

    -- 其他可选配置（未启用）：
    -- side = "left",           -- 文件树显示在左侧（默认）或右侧
    -- number = false,          -- 是否显示绝对行号
    -- signcolumn = "yes",      -- 是否显示符号列（git 状态等）
  },

  -- ========== 文件树渲染样式 ==========
  renderer = {
    -- 缩进标记配置
    indent_markers = {
      -- 是否显示层级虚线引导线
      -- true: 显示类似 "├──" 的缩进线，层级更清晰
      -- false: 不显示引导线
      enable = true,
    },

    -- 图标配置
    icons = {
      -- -- 关闭图标字符集配置
      -- show = {
      -- 	file = false,      -- 不显示文件图标
      -- 	folder = false,    -- 不显示文件夹图标
      -- 	folder_arrow = false,  -- 不显示文件夹箭头
      -- 	git = false,       -- 不显示 git 图标
      -- },
      -- glyphs = {
      -- 	-- 清空所有图标
      -- 	folder = {
      -- 		default = "",
      -- 		open = "",
      -- 	},
      -- },

      -- 自定义图标字符集配置
      -- glyphs = {
      -- 	-- 文件夹图标（这里设置为空表，会清空默认图标）
      -- 	-- 通常建议不设置此项，让 nvim-web-devicons 自动处理
      -- 	-- 或者自定义为：
      -- 	-- folder = {
      -- 	--     default = "",   -- 默认文件夹图标
      -- 	--     open = "",      -- 展开的文件夹图标
      -- 	--     empty = "",     -- 空文件夹图标
      -- 	--     symlink = "",   -- 符号链接文件夹图标
      -- 	-- }
      -- 	folder = {},
      -- 	-- 其他可选图标配置（未启用）：
      -- 	-- file = {
      -- 	--     default = "󰈙",   -- 默认文件图标
      -- 	--     symlink = "",   -- 符号链接文件图标
      -- 	-- },
      -- 	-- git = {
      -- 	--     unstaged = "",   -- git 未暂存标记
      -- 	--     staged = "S",     -- git 已暂存标记
      -- 	--     unmerged = "",   -- git 冲突标记
      -- 	-- },
      -- },
    },

  -- 其他可选渲染配置（未启用）：
  -- highlight_git = true,      -- 高亮 git 状态
  -- highlight_opened_files = "all",  -- 高亮打开的文件
  -- indent_markers = {
  -- 	inline_arrows = false,  -- 是否使用内联箭头
  -- },
  },

  -- ========== 操作行为配置 ==========
  actions = {
    -- 打开文件相关配置
    open_file = {
    -- 窗口选择器配置
    window_picker = {
      -- 是否启用窗口选择器
      -- false: 禁用，直接在当前聚焦的窗口打开文件
      -- true:  启用，会弹出提示让你选择在哪个窗口打开
      -- 
      -- 禁用原因：配合窗口分屏使用时更流畅，
      -- 手动切换窗口比每次都选择更高效
      enable = false,
    },
    },
    
    -- 其他可选操作配置（未启用）：
    -- change_dir = {
    -- 	enable = true,      -- 是否允许更改当前目录
    -- 	global = false,     -- 是否全局生效
    -- },
  },

  -- ========== 文件过滤配置 ==========
  filters = {
    -- 自定义过滤规则（不显示的文件/文件夹）
    -- 支持通配符和 Lua 正则表达式
    custom = {
    -- "node_modules",   -- 可以隐藏依赖目录
    -- "*.log",          -- 隐藏日志文件
    -- "__pycache__",    -- 隐藏 Python 缓存
    },
    
    -- 其他可选过滤配置（未启用）：
    -- dotfiles = false,    -- 是否隐藏点文件（.开头）
    -- exclude = {},        -- 排除特定模式
  },

  -- ========== Git 集成配置 ==========
  git = {
    -- 是否忽略 .gitignore 中的文件
    -- false: 显示被 git 忽略的文件（如 node_modules）
    -- true:  隐藏被 git 忽略的文件
    -- 
    -- 设为 false 的场景：需要查看或编辑被忽略的配置文件时
    ignore = false,
    
    -- 其他可选 git 配置（未启用）：
    -- show_on_dirs = true,    -- 在目录上显示 git 状态
    -- show_on_open_dirs = true, -- 在打开的目录上显示
    -- timeout = 400,          -- git 命令超时时间（毫秒）
  },

  -- ========== 其他实用配置（未在此配置文件中启用） ==========
  -- 以下是一些常见的其他配置项，供参考：

  -- 自动关闭文件树
  -- on_attach = function(bufnr)
  -- 	local api = require("nvim-tree.api")
  -- 	api.map.on_attach.default(bufnr)
  -- 	-- 打开文件后自动关闭文件树窗口
  -- 	api.events.subscribe(api.events.Event.FileOpen, function()
  -- 		api.tree.close()
  -- 	end)
  -- end,

  -- 禁用系统监视器（提高性能）
  -- disable_netrw = true,      -- 禁用 netrw（已在外层设置）
  -- hijack_netrw = true,       -- 劫持 netrw 命令

  -- 同步光标位置
  -- update_focused_file = {
  -- 	enable = true,          -- 启用同步
  -- 	update_cwd = true,      -- 同时更新当前工作目录
  -- 	ignore_list = {},       -- 忽略的文件列表
  -- },

  -- 诊断配置
  -- diagnostics = {
  -- 	enable = true,          -- 显示 LSP 诊断信息
  -- 	show_on_dirs = true,    -- 在目录上显示
  -- 	icons = {               -- 诊断图标
  -- 		hint = "",
  -- 		info = "",
  -- 		warning = "",
  -- 		error = "",
  -- 	},
  -- },

  -- 通知配置
  -- notify = {
  -- 	threshold = vim.log.levels.INFO,  -- 通知级别
  -- 	absolute_path = true,              -- 显示绝对路径
  -- },
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

--	常用键
--	a:	新建文件/文件夹
--	d:	删除
--	r:	重命名
--	c:	复制
--	x:	剪切
--	p:	粘贴
--	y:	复制文件名
--	Y:	复制相对路径
--	gy:	复制绝对路径
--	v:	垂直分屏打开
--	s:	水平分屏打开
--	<Tab>:	新标签页打开
--	q:	关闭文件树
--	R:	刷新
--	H:	显示/隐藏隐藏文件
--	f:	过滤文件
--	g?:	显示帮助
