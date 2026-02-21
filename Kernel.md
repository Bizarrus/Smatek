# 1. Download
```
cd ~
git clone https://github.com/aosp-rockchip/android_kernel_rockchip_rk356x.git RockchipKernel
cd RockchipKernel
```

# 2. Build
```
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make rk356x_eink_defconfig

# Build! (~10 Minutes, depends on hardware)
make -j$(nproc)
```

If the build was successfully, you can continue with [Integrating the Kernel](Integrate.md)
