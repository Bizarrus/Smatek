# 1. Download
```
cd ~
git clone https://github.com/rockchip-linux/kernel.git RockchipKernel
cd RockchipKernel
```

# 2. Build
```
make rockchip_linux_defconfig ARCH=arm64

# Build! (~10 Minutes, depends on hardware)
make -j16 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
```
