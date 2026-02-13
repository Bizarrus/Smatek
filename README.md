> [!NOTE]
> Please use `Ubuntu 20.04 LTS` for compatibility and depencies purposes.

### WSL
> wsl --install -d Ubuntu-20.04

# Packages
```bash
sudo apt update && sudo apt upgrade -y && sudo apt install -y build-essential git gnupg flex bison gperf sdcc zip curl openjdk-11-jdk openjdk-11-jre lib32z1 lib32ncurses6 libncurses6 lib32stdc++6 libstdc++6 zlib1g libtinfo5 libffi7 libffi-dev python3-dev python-is-python3 ccache gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libssl-dev libncurses5
```

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

## Download `Android 11`
```bash
# 1. Workspace
mkdir -p ~/Android/aosp && cd ~/Android/aosp

# 2. AOSP Android 11
repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r48

# 3. Sync (~30-40 Min, depends on internet connection)
repo sync -j4 -c
```

## Build `Android 11`
```bash
# 4. Apply build-environment
source build/envsetup.sh
lunch aosp_arm64-eng

# 5. Build! (~40-50 Min, depends on hardware)
make -j16
```
