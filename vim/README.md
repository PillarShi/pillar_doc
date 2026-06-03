# VIM

## 最小配置

不在额外安装其他内容下进行配置

### vim

Windows 下将配置 [`.vimrc`](./vim/.vimrc) 放在 `C:\Users\user` 目录下。

Linux 放在 `~` 目录下。

### neovim

Windows 下将配置 [`init.vim`](./nvim/init.vim) 放在 `C:\Users\user\AppData\Local\nvim` 目录下。

Linux 放在 `~/.config/nvim` 目录下。

## 完全配置

对比下来，虽然两者都配置复杂，但总体 nvim 确实比较省心些，现代化些（只是lua比较讨厌吧，基础配置下lua也不用怎么搞，还能接受）

可以将 `./nvim/nvim` 放置之前放 `init.vim` 的位置。（`init.vim`需要去除）

拷贝/软连接

### 安装依赖

1. 下载字体
2. nvim-treesitter -- 暂弃：
   - C编译器
     - windows：安装[Microsoft C++ 生成工具](https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/)，勾选"使用C++的桌面开发"工作负载，确保安装"Windows SDK"组件
   - 安装[tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/releases)
3. pyright lsp -- 暂弃：
   npm
4. asm lsp -- 暂弃：
   安装 Rust 工具链（失败安装重试`rustup default stable`

---

相关参考：

- https://kznleaf.top/2026/04/25/From-lazy-to-vimpack/#nvim-treesitter
- https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/#%E6%80%BB%E7%BB%93
- https://www.bilibili.com/video/BV1N6ZRY7Etj/?p=15&share_source=copy_web&vd_source=5fa7b3693d8da11802d9a9ea8897259d
