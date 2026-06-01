vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim'
})

vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.statusline = ""

-- 基本上是默认配置 AI 注释
require('lualine').setup {
  -- ============================================================================
  -- options: 全局外观和行为配置
  -- ============================================================================
  options = {
    -- 是否显示图标（需要安装 nerd-font 等图标字体）
    -- 设为 true 时，mode、branch、diagnostics 等组件会显示图标
    icons_enabled = true,

    -- 主题：'auto' 会自动匹配当前 colorscheme
    -- 也可以设为具体主题名，如 'onedark'、'catppuccin'、'tokyonight'
    theme = 'auto',

    -- 组件之间的分隔符（同一个 section 内部，如 lualine_c 中 filename 和其右侧组件之间）
    -- left:  左分隔符，使用 Powerline 实心三角 
    -- right: 右分隔符，使用 Powerline 空心三角 
    component_separators = { left = '', right = '' },

    -- section 之间的分隔符（如 lualine_a 到 lualine_b 的过渡）
    -- left:  左分隔符 （实心三角，常用于左侧深→浅色过渡）
    -- right: 右分隔符 （实心三角，常用于右侧浅→深色过渡）
    section_separators = { left = '', right = '' },

    -- 对哪些文件类型禁用状态栏（statusline）和窗口栏（winbar）
    -- 目前为空，表示所有文件类型都显示
    disabled_filetypes = {
      -- 例如可添加 'NvimTree' 来在文件树中隐藏状态栏
      statusline = {},
      winbar = {
        "NvimTree"
      },
    },

    -- 当窗口失去焦点时，哪些 section 要隐藏
    -- 目前为空，表示模糊窗口（如 telescope）不会隐藏状态栏组件
    ignore_focus = {},

    -- 是否始终将 statusline 等分为左右两半
    -- true: 即使左侧内容很少，%= 也会出现在正中间
    always_divide_middle = true,

    -- 是否始终显示标签栏（tabline）
    -- true: 即使只有一个标签页也会显示
    always_show_tabline = true,

    -- 是否使用全局状态栏（所有窗口共享一个状态栏）
    -- false: 每个窗口都有自己的状态栏（独立显示该窗口的信息）
    globalstatus = false,

    -- 刷新控制
    refresh = {
      -- 状态栏基础刷新间隔（毫秒），配合 events 触发
      statusline = 1000,
      -- 标签栏基础刷新间隔
      tabline = 1000,
      -- 窗口栏基础刷新间隔
      winbar = 1000,
      -- 高频刷新时的最小间隔（约 60fps），用于 CursorMoved 等事件
      refresh_time = 16,
      -- 触发状态栏刷新的事件列表
      events = {
        'WinEnter',                -- 进入窗口时
        'BufEnter',                -- 进入缓冲区时
        'BufWritePost',            -- 保存文件后（更新 modified 图标等）
        'SessionLoadPost',         -- 加载 session 后
        'FileChangedShellPost',    -- 文件被外部修改后
        'VimResized',              -- 终端窗口大小改变时
        'Filetype',                -- 文件类型改变时
        'CursorMoved',             -- 光标移动（普通模式）
        'CursorMovedI',            -- 光标移动（插入模式）
        'ModeChanged',             -- 模式切换（如 normal→insert）
      },
    }
  },

  -- ============================================================================
  -- sections: 活动窗口的状态栏布局
  -- 状态栏分为 6 个区域：a b c | x y z （中间为自然分割）
  -- ============================================================================
  sections = {
    -- 最左侧，通常显示当前模式（NORMAL、INSERT、VISUAL 等）
    lualine_a = {'mode'},

    -- 左侧第二段，通常显示版本控制信息
    lualine_b = {
      'branch',        -- Git 分支名（如 main、feature/xxx）
      'diff',          -- Git 差异统计（+添加 -删除 ~修改）
      'diagnostics',   -- LSP 诊断信息（错误E 警告W 提示I 建议H 数量）
    },

    -- 左侧第三段（最长的左侧区域），通常显示文件名
    lualine_c = {
      -- {
      -- 	-- 当前文件名，含 modified/modifiable 标志
      -- 	'filename',
      -- 	-- 0 = 仅文件名, 1 = 相对路径, 2 = 绝对路径, 3 = 绝对路径（缩短显示）, 4 = 相对于 HOME 的路径
      -- 	path = 1,
      -- }
    },

    -- 右侧第三段（靠左的右侧区域），显示文件属性
    lualine_x = {
      -- 显示制表符信息
      function()
        local expandtab = vim.bo.expandtab and "SPC" or "TAB"
        local width = vim.bo.tabstop
        return string.format("%s:%d", expandtab, width)
      end,
      -- 文件编码（如 UTF-8、UTF-16）
      'encoding',
      -- 换行符格式（unix→LF、dos→CRLF、mac→CR）
      {
        'fileformat',
        symbols = {
          unix = ' LF',    -- 默认 ✓ 或 （图标）
          dos = ' CRLF',   -- 默认 
          mac = ' CR',     -- 默认 
        }
      },
      -- 文件类型（如 lua、python、javascript）
      'filetype',
    },

    -- 右侧第二段，显示文件进度
    lualine_y = {
      'progress',      -- 当前位置百分比（如 45%）
    },

    -- 最右侧，显示光标位置
    lualine_z = {
      'location',      -- 行号:列号（如 42:10）
    }
  },

  -- ============================================================================
  -- inactive_sections: 非活动窗口的状态栏布局
  -- 当某个窗口不是当前焦点窗口时，显示简化版状态栏
  -- ============================================================================
  inactive_sections = {
    lualine_a = {},         -- 不显示模式（非活动窗口没有"当前模式"概念）
    lualine_b = {},         -- 不显示 Git 信息
    lualine_c = {
      -- 保留文件名，方便识别窗口内容
      -- { 'filename', path = 1 }
    },
    lualine_x = {
      'location'      -- 保留光标位置（显示在右侧，因为最有用）
    },
    lualine_y = {},
    lualine_z = {}
  },

  -- ============================================================================
  -- tabline: 顶部标签栏配置（当前为空，使用默认行为）
  -- 可添加 'tabs' 和 'buffers' 组件来显示标签和缓冲区列表
  -- 例如：tabline = { lualine_a = {'buffers'}, lualine_z = {'tabs'} }
  -- ============================================================================
  tabline = {
    -- lualine_a = {'buffers'},
    -- lualine_z = {'tabs'}
  },

  -- ============================================================================
  -- winbar: 窗口顶部栏配置（当前为空，不显示窗口栏）
  -- 需要 Neovim ≥ 0.8，可作为每个窗口的"面包屑导航"或上下文信息栏
  -- 例如：winbar = { lualine_c = {'filename'} }
  -- ============================================================================
  winbar = {
    lualine_c = {
      {
        -- 当前文件名，含 modified/modifiable 标志
        'filename',
        -- 0 = 仅文件名, 1 = 相对路径, 2 = 绝对路径, 3 = 绝对路径（缩短显示）, 4 = 相对于 HOME 的路径
        path = 1,
      }
    }
  },

  -- ============================================================================
  -- inactive_winbar: 非活动窗口的顶部栏配置
  -- ============================================================================
  inactive_winbar = {
    lualine_c = {
      {
        -- 当前文件名，含 modified/modifiable 标志
        'filename',
        -- 0 = 仅文件名, 1 = 相对路径, 2 = 绝对路径, 3 = 绝对路径（缩短显示）, 4 = 相对于 HOME 的路径
        path = 1,
      }
    }
  },

  -- ============================================================================
  -- extensions: 启用额外的插件集成
  -- 可选值包括：'fugitive'、'fzf'、'nerdtree'、'nvim-tree'、'quickfix'、'toggleterm' 等
  -- 启用后，LuaLine 会在这些插件的窗口中显示对应的状态信息
  -- ============================================================================
  extensions = {}
}
