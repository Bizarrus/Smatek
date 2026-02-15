# Go into Flashing-Mode
```
# Set the Bootloader-Mode on device
# Option A: with rkdeveloptool
rkdeveloptool rd
# Then: press and hold Power + Vol Down buttons

# Option B: With adb
adb reboot bootloader
```

## Backup old System
You can check the old partitions with
```
rkdeveloptool ppt
```
You can backup the partitions with:
```
rkdeveloptool rkf <name> <name>.img
```

For a simple and full backup process, use our tool [backup.sh](backup.sh)!

## Start flashing
```
# Check if the device will be displayed
rkdeveloptool ld

# Flashing the Images
rkdeveloptool wlx boot boot.img
rkdeveloptool wlx system system.img
rkdeveloptool wlx vendor vendor.img
rkdeveloptool wlx recovery recovery.img
# (Optional: super.img, userdata.img)

# Restart
rkdeveloptool rd
```
