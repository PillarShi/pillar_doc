vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

-- 当插件包发生变化时自动触发（安装、更新、卸载等）
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    -- 从事件数据中提取包名和变化类型
    local name, kind = ev.data.spec.name, ev.data.kind
    -- 如果是 nvim-treesitter 被更新了
    if name == "nvim-treesitter" and kind == "update" then
      -- 如果包还未激活，手动加载它
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      -- 执行 Treesitter 更新命令，更新所有已安装的解析器
      vim.cmd("TSUpdate")
    end
  end,
})

-- 安装 Treesitter 语法解析器（按需安装所需语言）
require("nvim-treesitter").install({
  "asm",              -- asm 汇编
  "bash",             -- Bash 脚本
  "c",                -- C 语言
  "cmake",            -- cmake 脚本
  "cpp",              -- C++ 语言
  "doxygen",          -- Doxygen 注释
  "dockerfile",       -- docker file
  "diff",             -- Git diff/统一差异格式输出
  "git_rebase",       -- Git 交互式 rebase 文件
  "gitcommit",        -- Git 提交信息编辑
  "gitattributes",    -- Git 属性配置文件
  "gitignore",        -- Git 忽略规则文件
  "json",             -- JSON 数据格式
  "lua",              -- Lua 语言
  "markdown",         -- Markdown 文档
  "markdown_inline",  -- Markdown 内联元素
  "make",             -- make 脚本
  "ninja",            -- ninja 脚本
  "objdump",          -- objdump C
  "python",           -- Python 语言
  "proto",            -- Protocol Buffers
  "query",            -- Treesitter 查询语法
  "vim",              -- Vimscript
  "vimdoc",           -- Vim 帮助文档
  "yaml",             -- YAML 配置文件
})

require("nvim-treesitter").setup({ highlight = { enable = true } })
