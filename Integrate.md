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
~/Android/aosp/out/host/linux-x86/bin/mkbootimg \
  --kernel arch/arm64/boot/Image.gz \
  --ramdisk ~/Android/aosp/out/target/product/generic/ramdisk.img \
  --dtb arch/arm64/boot/dts/rockchip/rk3566-evb2-lp4x-v10.dtb \
  --kernel_offset 0x10008000 \
  --ramdisk_offset 0x11000000 \
  --tags_offset 0x10000100 \
  --dtb_offset 0x11f00000 \
  --pagesize 2048 \
  --header_version 2 \
  --os_version 11.0.0 \
  --os_patch_level 2021-10 \
  --cmdline "console=ttyFIQ0 androidboot.baseband=N/A androidboot.wificountrycode=CN androidboot.veritymode=enforcing androidboot.hardware=rk30board androidboot.console=ttyFIQ0 androidboot.verifiedbootstate=orange firmware_class.path=/vendor/etc/firmware init=/init rootwait ro loop.max_part=7 buildvariant=userdebug" \
  -o boot.img
```
