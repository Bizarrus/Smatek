> [!NOTE]
> Please use `Ubuntu 20.04 LTS` for compatibility and depencies purposes.

### WSL
> wsl --install -d Ubuntu-20.04

# Packages
```bash
sudo apt update && sudo apt upgrade -y && sudo apt install -y build-essential git gnupg flex bison gperf sdcc zip curl openjdk-11-jdk openjdk-11-jre lib32z1 lib32ncurses6 libncurses6 lib32stdc++6 libstdc++6 zlib1g libtinfo5 libffi7 libffi-dev python3-dev python-is-python3 ccache gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libssl-dev libncurses5
```

## Step-by-Step Guide
1. [Download and build Android](Android.md)
2. [Download and build Kernel from Rockchip](Kernel.md)
3. [Integrate the Kernel in Android](Integrate.md)
4. Update Configurations
5. Integrate Smatek & Rockchip Service
6. Adding Pre-Installed Apps
7. [Flashing Device](Flashing.md)
