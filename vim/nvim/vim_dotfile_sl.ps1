# 请求管理员权限
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process PowerShell -Verb RunAs -ArgumentList "-File `"$PSCommandPath`""
    exit
}
# 进入当前脚本目录 -- 方便相对路径
cd $PSScriptRoot

# 创建目录符号链接
$targetPath = "$env:LOCALAPPDATA\nvim"
$sourcePath = ".\nvim"
New-Item -Path $targetPath -ItemType Directory -Force

New-Item -ItemType SymbolicLink -Path "$targetPath\lua" -Target "$sourcePath\lua" -Force
New-Item -ItemType SymbolicLink -Path "$targetPath\init.lua" -Target "$sourcePath\init.lua" -Force

Read-Host "wait for any key..."
