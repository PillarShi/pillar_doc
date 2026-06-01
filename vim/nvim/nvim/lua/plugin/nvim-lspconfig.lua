vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" }
})

-- 在 LSP 附着到缓冲区时设置快捷键，当语言服务器(LSP)成功附加到当前缓冲区时触发该自动命令
vim.api.nvim_create_autocmd('LspAttach', {
  -- 创建一个自定义的自动命令组，便于管理和清除
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- 启用缓冲区级别的快捷键，这些快捷键仅在当前缓冲区生效，不会影响其他缓冲区
    local opts = { buffer = ev.buf }
    -- 设置浮动窗口边框颜色
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#8AAAE5", bg = "NONE" })
    -- 设置浮动窗口标题颜色
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#8AAAE5", bg = "NONE" })
    -- hover 配置
    local hover_func = function()
      return vim.lsp.buf.hover({
        border = "rounded",
        max_width = math.floor(vim.o.columns / 2),  -- 限制宽度
        max_height = math.floor(vim.o.lines / 2.5), -- 限制高度
        zindex = 50,                                -- 层级
      })
    end
    -- hover 配置
    local diagnostic_open_float = function()
      return vim.diagnostic.open_float({
        border = "rounded",
        max_width = math.floor(vim.o.columns / 2),  -- 限制宽度
        max_height = math.floor(vim.o.lines / 2.5), -- 限制高度
        zindex = 50,                                -- 层级
      })
    end

    vim.keymap.set('n', 'K', hover_func, opts) -- 悬浮提示
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- 转到定义：跳转到变量/函数的定义位置
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- 转到声明：跳转到变量/函数的声明位置
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- 转到实现：跳转到接口的具体实现
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts) -- 转到类型定义：跳转到类型的定义位置
    -- 代码操作相关快捷键
    vim.keymap.set('v', '=', vim.lsp.buf.format, opts) -- 格式化：使用LSP格式化当前缓冲区代码
    -- 诊断相关快捷键
    vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts) -- 上一个诊断：跳转到上一个错误/警告位置
    vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, opts) -- 下一个诊断：跳转到下一个错误/警告位置
    vim.keymap.set('n', '<leader>ds', diagnostic_open_float, opts) -- 显示诊断详情：在悬浮窗口显示当前行的诊断信息
    vim.keymap.set('n', '<leader>da', vim.diagnostic.setloclist, opts)
  end,
})

-------------------------------------------------------------------------------
-- clangd
-------------------------------------------------------------------------------
-- local clangd_opts = {
--   -- 使用自定义命令和参数
--   cmd = { 
--     'clangd',
--     '--background-index',
--     '--background-index-priority=low',
--     '--clang-tidy',
--     '--completion-style=detailed',
--     '--fallback-style=Google',
--     '--function-arg-placeholders=false',
--     '--header-insertion-decorators',
--     '--import-insertions',
--     '--rename-file-limit=0',
--     '--enable-config',
--     '-j=8',
--     '--pch-storage=memory',
--     '--pretty',
--   },
-- }
-- vim.lsp.enable('clangd', clangd_opts)
-- 上面在使用nvim-lspconfig下不起作用，仅为记录
vim.lsp.enable('clangd')

-------------------------------------------------------------------------------
-- lua
-------------------------------------------------------------------------------
vim.lsp.enable('lua_ls')

-------------------------------------------------------------------------------
-- python
-------------------------------------------------------------------------------
vim.lsp.enable('basedpyright')

-------------------------------------------------------------------------------
-- cmake
-------------------------------------------------------------------------------
vim.lsp.enable('neocmake')

-------------------------------------------------------------------------------
-- make
-------------------------------------------------------------------------------
vim.lsp.enable('autotools_ls')
