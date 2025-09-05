
vscode setting

```setting
{
    "workbench.colorTheme": "Default Dark+",
    "workbench.iconTheme": "material-icon-theme",
    "files.autoSave": "afterDelay",
    "editor.fontSize": 17,
    "editor.bracketPairColorization.enabled": false,
    "editor.rulers": [
        80
    ],
    "terminal.integrated.fontSize": 15,
    "terminal.integrated.cursorBlinking": true,
    // "accessibility.signalOptions.volume": 0,
    // "hediet.vscode-drawio.resizeImages": null,
    "C_Cpp.intelliSenseEngine": "disabled", // 禁用 IntelliSense 引擎
    "C_Cpp.autocomplete": "disabled", // 禁用自动补全功能
    "C_Cpp.errorSquiggles": "disabled", // 禁用错误波浪线提示
    "clangd.path": "clangd",
    "clangd.arguments": [
        // 在后台自动构建索引，提高代码导航和补全性能
        "--background-index",
        // 设置后台索引任务的优先级为低，减少对系统性能的影响
        "--background-index-priority=low",
        // 启用 Clang-Tidy 静态分析，提供代码质量检查和建议
        "--clang-tidy",
        // 使用详细的补全样式，提供更多信息（如函数参数和返回类型）
        "--completion-style=detailed",
        // 当没有找到其他样式配置时，使用 Google 代码风格作为回退
        "--fallback-style=Google",
        // 禁用函数参数占位符（某些客户端中函数调用时不自动生成参数名占位符）
        "--function-arg-placeholders=false",
        // 禁止自动插入头文件
        "--header-insertion=never",
        // 启用头文件插入装饰器（与header-insertion配合使用，但此处已禁用插入）
        "--header-insertion-decorators",
        // 允许在代码补全时建议导入语句
        "--import-insertions",
        // 设置重命名操作时不考虑文件数量限制（0表示无限制）
        "--rename-file-limit=0",
        // 启用项目特定的配置文件（如.clangd）
        "--enable-config",
        // 使用24个线程并行处理，加速索引和编译操作
        "-j=8",
        // 将预编译头文件存储在内存中，提高性能但增加内存使用
        "--pch-storage=memory",
        // 输出美观格式的诊断信息
        "--pretty",
        // // 指定查询驱动程序工具的路径（用于获取系统头文件路径等）
        // "--query-driver=${userHome}/arm-none-eabi-gcc/14.2.1/bin/arm-none-eabi-g*"
        // 指定编译命令数据库的目录路径（用于获取项目的编译设置）
        "--compile-commands-dir=${workspaceFolder}/.vscode",
    ]
}
```
