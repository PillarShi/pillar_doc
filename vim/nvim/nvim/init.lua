-- 通用设置
require('config')

-- 根据文件区分tab等设置
require('files_tab')

-- 按键设置
require('keymap')

-- 插件配置
-- 也可以在当前目录下直接创建 plugin 目录，在其下的lua可以直接自动执行
-- 为了方便手动管理，暂时没这么做
require('plugin')
