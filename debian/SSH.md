```bash
sudo apt remove openssh-server # 下载
```

在主机目录`C:\Users\自己的用户名\.ssh\config`下添加例如
```
Host debian
  HostName 192.168.1.2
  User pillar
  Port 22
```
