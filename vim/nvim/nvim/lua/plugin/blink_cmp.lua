-- 延迟加载函数：在 Neovim 完全启动后才初始化补全系统
local start = function()
  -- 安装三个插件：
  -- 1. blink.cmp：高性能代码补全引擎
  -- 2. LuaSnip：代码片段引擎
  -- 3. friendly-snippets：社区预置的代码片段集合
  vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",
  })

  -- blink.cmp 主配置
  require("blink.cmp").setup({
    -- 使用 LuaSnip 作为代码片段引擎
    snippets = { preset = "luasnip" },

    -- 快捷键配置
    -- 预设按键说明：
    --   Ctrl+E        隐藏补全菜单
    --   Ctrl+N/Ctrl+P 选择下一个/上一个补全项
    --   上/下方向键    同上
    --   Ctrl+K        切换函数签名帮助
    --   Tab/Shift+Tab 在代码片段占位符之间跳转
    --   Ctrl+Y        选择并接受当前补全
    keymap = {
      preset = "default", -- 使用默认按键预设
      -- 用 Ctrl+G 替代默认的 Ctrl+Space，避免与输入法切换冲突
      -- 按一次：显示补全菜单，按第二次：显示文档，按第三次：隐藏文档
      ["<C-g>"] = { "show", "show_documentation", "hide_documentation" },
    },

    -- 补全行为配置
    completion = {
      documentation = {
        auto_show = true,             -- 自动显示函数/变量文档
        auto_show_delay_ms = 500,     -- 选中补全项后延迟 500ms 再显示文档（避免快速移动时频繁弹出）
        window = { border = "rounded" }, -- 文档窗口使用圆角边框
      },
      menu = {
        -- border = "rounded",        -- 补全菜单边框设置（当前使用默认样式）
      },
    },

    -- 补全来源及其优先级（越靠前优先级越高）
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- lsp:      语言服务器提供的智能补全（类型、函数、变量等）
      -- path:     文件路径补全（输入路径时自动提示）
      -- snippets: 代码片段（循环、条件语句等模板）
      -- buffer:   当前文件中的单词（作为候选项）
    },

    -- 启用函数签名帮助（输入函数参数时显示参数列表和类型）
    signature = { enabled = true },
  })

  -- 加载 friendly-snippets 中的所有 VSCode 格式代码片段
  -- 包括 JavaScript, TypeScript, Python, Rust 等常见语言的预置片段
  require("luasnip.loaders.from_vscode").lazy_load()
end

-- 在 Neovim 完全启动后（VimEnter 事件）才执行 start 函数
-- 原因：blink.cmp 初始化大约需要 30ms，延迟加载可以加快启动速度
-- once = true：确保这个自动命令只执行一次，避免重复加载
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = start,
})
