#!/bin/bash
# MuHanOS 12 GSI Build Script
# Based on AOSP android-12.1.0_r21
# Compatible with Redmi K20 Pro and Android Studio Emulator
#
# Requirements:
# - Ubuntu 20.04/22.04 (or similar Linux)
# - 16GB+ RAM (32GB recommended)
# - 150GB+ free disk space
# - OpenJDK 11 (openjdk-11-jdk)
# - Go 1.15.6 (AOSP 12.1 required version)
# - AOSP 12 source code synced with repo

set -e

echo "=========================================="
echo " MuHanOS 12 GSI Build Script"
echo " Version: Beta26.9.11"
echo " Maintainer: MuHan"
echo " Based on: AOSP android-12.1.0_r21"
echo "=========================================="

# ============================================
# Step 0: Environment (if needed)
# ============================================
if [ -f /etc/debian_version ]; then
  echo ""
  echo "[0/6] Installing build dependencies..."
  sudo apt-get update -qq
  sudo apt-get install -y openjdk-11-jdk python3 git repo curl zip unzip bc gnupg \
    flex bison gperf libssl-dev libncurses5-dev zlib1g-dev libbz2-dev \
    liblzma-dev libreadline-dev libsqlite3-dev libelf-dev libx11-dev \
    libxml2-utils xsltproc clang llvm lld protobuf-compiler 2>/dev/null
fi

# ============================================
# Step 1: Download Go 1.15.6 (AOSP 12.1 required)
# ============================================
echo ""
echo "[1/6] Setting up Go 1.15.6..."
if [ ! -d prebuilts/go/linux-x86 ]; then
  mkdir -p prebuilts/go
  curl -sSL -o /tmp/go1.15.tar.gz "https://dl.google.com/go/go1.15.6.linux-amd64.tar.gz"
  tar -xzf /tmp/go1.15.tar.gz -C prebuilts/go/
  mv prebuilts/go/go prebuilts/go/linux-x86
fi

export GOROOT=$(pwd)/prebuilts/go/linux-x86
export PATH=$GOROOT/bin:$PATH
echo "  Go version: $(go version)"

# ============================================
# Step 2: Java 11
# ============================================
echo ""
echo "[2/6] Setting up Java 11..."
export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-11-openjdk-amd64}
export PATH=$JAVA_HOME/bin:$PATH
echo "  Java version: $(java -version 2>&1 | head -1)"

# ============================================
# Step 3: MuHanOS vendor overlay
# ============================================
echo ""
echo "[3/6] Installing MuHanOS vendor overlay..."
MUHANOS_REPO="https://github.com/bilibiliHaoziyao/MuHanOS"
if [ -d vendor/muhanos/.git ]; then
  echo "  vendor/muhanos already exists, pulling latest..."
  (cd vendor/muhanos && git pull)
else
  echo "  Cloning MuHanOS vendor overlay..."
  git clone $MUHANOS_REPO vendor/muhanos_src
  # Copy product configs
  cp -r vendor/muhanos_src/vendor/muhanos vendor/muhanos
fi
echo "  MuHanOS overlay ready."

# ============================================
# Step 4: Source build env
# ============================================
echo ""
echo "[4/6] Sourcing AOSP build environment..."
source build/envsetup.sh

# ============================================
# Step 5: Lunch MuHanOS GSI
# ============================================
echo ""
echo "[5/6] Lunching mu_hanos_gsi-userdebug..."
lunch mu_hanos_gsi-userdebug

echo ""
echo "=========================================="
echo " Build Configuration"
echo "=========================================="
echo " TARGET_PRODUCT: $TARGET_PRODUCT"
echo " TARGET_BUILD_VARIANT: $TARGET_BUILD_VARIANT"
echo " TARGET_ARCH: $TARGET_ARCH"
echo " PRODUCT_BRAND: $PRODUCT_BRAND"
echo " PRODUCT_MODEL: $PRODUCT_MODEL"
echo " BUILD_ID: $BUILD_ID"
echo ""

# ============================================
# Step 6: Build GSI
# ============================================
echo "[6/6] Building MuHanOS 12 GSI system image..."
echo "  This may take 2-6 hours depending on your hardware."
echo ""

JOBS=$(nproc)
echo "  Using -j$JOBS parallel jobs"
echo ""

OUT_DIR_COMMON_BASE=${OUT_DIR_COMMON_BASE:-$HOME/out}

m -j$JOBS systemimage

echo ""
echo "=========================================="
echo " BUILD COMPLETE!"
echo "=========================================="
echo ""

# Show artifacts
echo " Build artifacts:"
ls -lh $OUT_DIR_COMMON_BASE/target/product/generic_arm64/system.img 2>/dev/null && \
  echo "  -> system.img (GSI)" || find out -name "system.img" 2>/dev/null | head -3

echo ""
echo " Flash to Redmi K20 Pro:"
echo "  fastboot flash system system.img"
echo ""
echo "=========================================="
echo " MuHanOS 12 Beta26.9.11 by MuHan"
echo "=========================================="
