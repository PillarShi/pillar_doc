
## 环境安装

参考[uboot 环境安装](../uboot_notes/00.环境安装.md)

```bash
sudo apt install bc
sudo apt install libssl-dev
```

## 编译

```bash
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- -j8
# 分开
# make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- Image -j8
# make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- modules -j8
# make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- dtbs
```

https://zhuanlan.zhihu.com/p/667525514
