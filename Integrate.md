# Integrate the Kernel in Android
```
cd ~/Android/aosp

# Copy Kernel
cp ~/RockchipKernel/arch/arm64/boot/Image device/generic/common/

# Copy Device Tree Blobs
cp -r ~/RockchipKernel/arch/arm64/boot/dts/rockchip/ device/generic/common/
```

## Rebuild Boot-Image with the new Kernel
```
source build/envsetup.sh
lunch aosp_arm64-eng
make bootimage -j16

# Build! (~10-30 Minutes, depends on hardware)
make -j16
```
