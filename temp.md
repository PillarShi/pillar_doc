
```bash
sudo apt install bc
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- -j8
# 分开
# make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- Image -j8
# make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- modules -j8
# make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- dtbs
```

https://zhuanlan.zhihu.com/p/667525514
