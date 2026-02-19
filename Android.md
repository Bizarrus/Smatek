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
repo sync -j4 -c
```

## Build `Android 13`
```bash
# 4. Apply build-environment
source build/envsetup.sh
lunch aosp_arm64-eng

# 5. Build! (~1-3 Hrs, depends on hardware)
# Sample: i9-11900K with 32GB RAM = 2,3 Hrs
make -j16
```

If the build was successfully, you can continue with [Kernel-Building](Kernel.md)
