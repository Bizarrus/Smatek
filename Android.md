## Pre-Requisites google Repositorys
```bash
mkdir -p ~/.local/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
chmod a+x ~/.local/bin/repo
echo 'export PATH=~/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Enable Build-Cache
```bash
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 100G

echo 'export USE_CCACHE=1' >> ~/.bashrc
echo 'export CCACHE_DIR=~/.ccache' >> ~/.bashrc
source ~/.bashrc
```

## Download `Android Go 13`
```bash
# 1. Workspace
mkdir -p ~/Android/aosp && cd ~/Android/aosp

# 2. AOSP Android Go 13
repo init -u https://android.googlesource.com/platform/manifest -b android-13.0.0_r1

# 3. Sync (~30-40 Min, depends on internet connection)
repo sync -j$(nproc) -c
```

## Pre-Configure the Build
```bash
# Disable Google Services
export PRODUCT_USE_GOOGLE_SERVICES=false

# Create Go-Definitions
mkdir -p device/aosp/go

# create AndroidProducts.mk
cat > device/aosp/go/AndroidProducts.mk << 'EOF'
PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/aosp_go_arm.mk

COMMON_LUNCH_CHOICES := \
    aosp_go_arm-eng \
    aosp_go_arm-userdebug
EOF

# create aosp_go_arm.mk
cat > device/aosp/go/aosp_go_arm.mk << 'EOF'
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_arm.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/go_defaults.mk)

PRODUCT_NAME := aosp_go_arm
PRODUCT_DEVICE := generic
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on ARM (Go)
EOF
```

## Build `Android 13`
```bash
# 4. Apply build-environment
source build/envsetup.sh

# Set the new Go target
lunch aosp_go_arm-eng

# 5. Build! (~1-3 Hrs, depends on hardware)
# Sample: i9-11900K with 32GB RAM = 2,3 Hrs
make -j$(nproc) SKIP_API_CHECKS=true WITHOUT_CHECK_API=true
```

If the build was successfully, you can continue with [Kernel-Building](Kernel.md)
