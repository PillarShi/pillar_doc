# debian13

## 1 修复环境变量

发现没有debian安装后没有自动添加环境变量，需要手动
1. 首先编辑配置文件

    ```bash
    # 切换root用户
    su
    nano /etc/profile # 没用，改输入下面的
    nano /etc/bash.bashrc
    ```

2. 在文件末尾添加如下内容

    ```bash
    export PATH=$PATH:/sbin/
    alias ll='ls -l'
    ```

3. 保存退出

    ```bash
    ctrl+o
    enter
    ctrl+x
    ```

## 2 换源

```bash
su
#打开源文件
nano /etc/apt/sources.list
```

将文件中的内容删除，将如下全部内容粘贴到文件中，以下为Debian13的清华源，Debian其他版本和其他Linux发行版请自行上网上查询源的内容

清华

```bash
#单纯下载可以只有第一行
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security trixie-security main contrib
```

阿里

```bash
deb https://mirrors.aliyun.com/debian/ trixie main contrib
deb https://mirrors.aliyun.com/debian/ trixie-updates main contrib
deb https://mirrors.aliyun.com/debian/ trixie-backports main contrib
deb https://mirrors.aliyun.com/debian-security trixie-security main contrib
```

按`Ctrl + X`离开，再按`Y`保存

使用`nala`搜索最适合源

```bash
apt update
apt install nala -y
nala fetch
nala update
```

## 3 添加用户组

安装debian完成后sudo命令用不了，要把当前用户加入sudo用户组

```bash
su

apt install sudo

cd /sbin/
# 加入sudo用户组
./usermod -aG sudo 要加入的用户名
# 推荐加入dialout用户组使用串口更方便
./usermod -a -G dialout 要加入的用户名
# 重启
./reboot
```

## 4 安装软件

可以apt也可以nala

```bash
apt intstall -y net-tools ssh
apt install -y vim p7zip-full curl
apt install -y git python-is-python3
apt install -y build-essential ninja-build # gnu + ninja
sudo apt install fonts-noto-cjk // 中文字体包
```

# 其他

## 静态IPV4

```bash
ip route show default # 输出结果中 via 后面的那个IP地址就是你的网关地址
sudo cp /etc/network/interfaces /etc/network/interfaces.backup # 备份
sudo vim /etc/network/interfaces
```

```interfaces
# 可能原先的
allow-hotplug enp0s3
iface enp0s3 inet dhcp
# 修改为
allow-hotplug enp0s3
iface enp0s3 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    broadcast 192.168.1.255
```

```bash
sudo systemctl restart networking # 重启网络
ping baidu.com
```

## VPN

linux可以使用[v2raya](https://github.com/v2rayA/v2rayA)

## dwm

[官网地址](https://dwm.suckless.org/)

```bash
sudo apt install libx11-dev libxft-dev libxinerama-dev # 安装依赖
sudo apt install xinit # x服务器
tar -xzvf dwmxxx.tar.gz
cd dwmxxx
make clean install # 编译安装
vim ~/.xinitrc
# 添加
exec dwm
# 保存文件运行
startx
```

## ipv6 关闭

```bash
sudo vim /etc/sysctl.conf

# 写入
net.ipv6.conf.all.disable_ipv6=1 #禁用所有网络接口ipv6
net.ipv6.conf.default.disable_ipv6=1 # 禁用新创建的网络接口ipv6
net.ipv6.conf.lo.disable_ipv6=1 # 禁用回环接口ipv6

# 执行以下命令让配置立即生效
sudo sysctl -p
```

## claude-code

```bash
sudo apt install nodejs npm
sudo npm install -g @anthropic-ai/claude-code
# sudo npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com # 淘宝镜像源
claude
```

## qemu

```bash
sudo apt install qemu-system qemu-utils
```

## uboot编译

```bash
sudo apt install bison flex
```
