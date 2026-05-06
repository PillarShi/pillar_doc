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
