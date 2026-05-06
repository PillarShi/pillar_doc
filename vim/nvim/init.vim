" 显示行号
set number

" 显示相对行号
"set relativenumber

" 显示光标当前位置
set ruler

" 光标行高亮
"set cursorline

" 制表符显示的宽度
set tabstop=8

" 将制表符转换为空格 (默认注释，需要时取消注释)
"set expandtab

" 自动缩进
set autoindent

" 设置配色方案 (确保已安装对应主题)
"colorscheme evening
"colorscheme industry
"colorscheme pablo
"colorscheme slate

" 语法高亮
syntax on

" 设置拆分默认为向下
" bel -- 下
" top -- 上
set splitbelow

" 设置垂直拆分时默认向右
"set splitright

" 显示当前模式 (Neovim 默认已显示，但显式开启无妨)
set showmode

" 显示输入的命令
set showcmd

" 总是显示状态栏
set laststatus=2

" 设置状态行显示内容
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%P]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=%#StatusLineTerm#\ %<%.20f%m%r\ %#StatusLineNC#\ [%{&ff}]\ [%Y]\ %=\ %l:%c\ %p%%\ %{strftime('%R')}

" 设置光标样式
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

" 启用鼠标支持 (可选择、滚动等)
set mouse=a

" 修复 Insert 模式下退格键失效问题
set backspace=indent,eol,start

" 取消备份文件
set nobackup
set nowritebackup
set noswapfile

" 关闭提示音
set belloff=all

" Windows 配置
if has('win32')
	" Neovim 推荐使用终端模拟器或窗口管理器实现，故默认注释
	" autocmd GUIEnter * simalt ~x

	" 终端设置
	set shell=powershell.exe
endif
