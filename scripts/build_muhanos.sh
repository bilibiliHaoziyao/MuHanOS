#!/bin/bash
# MuHanOS 12 GSI Build Script
# Based on AOSP android-12.1.0_r21
# Compatible with Redmi K20 Pro and Android Studio Emulator
#
# Requirements:
# - Ubuntu 20.04/22.04 (or similar Linux)
# - 16GB+ RAM (32GB recommended)
# - 150GB+ free disk space
# - Go 1.17.x
# - OpenJDK 11
# - AOSP 12 source code synced with repo

set -e

echo "=========================================="
echo " MuHanOS 12 GSI Build Script"
echo " Version: Beta26.9.11"
echo " Maintainer: MuHan"
echo "=========================================="

# ============================================
# Environment Setup
# ============================================
export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-11-openjdk-amd64}
export GOROOT=${GOROOT:-$HOME/prebuilts/go/linux-x86}
export PATH=$JAVA_HOME/bin:$GOROOT/bin:$PATH
export TZ=Asia/Shanghai
export OUT_DIR_COMMON_BASE=${OUT_DIR_COMMON_BASE:-$HOME/out}

echo ""
echo "[1/5] Checking environment..."
echo "  JAVA_HOME: $JAVA_HOME"
echo "  GOROOT: $GOROOT"
echo "  Java: $(java -version 2>&1)"
echo "  Go: $(go version)"
echo ""

# ============================================
# Source AOSP build environment
# ============================================
echo "[2/5] Sourcing AOSP build environment..."
source build/envsetup.sh

# ============================================
# Lunch MuHanOS GSI
# ============================================
echo "[3/5] Lunching mu_hanos_gsi-userdebug..."
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
echo ""

# ============================================
# Build GSI system image
# ============================================
echo "[4/5] Building MuHanOS 12 GSI system image..."
echo "  This may take 2-4 hours depending on your hardware."
echo ""

# Use all available cores for parallel build
JOBS=$(nproc)
echo "  Using $JOBS parallel jobs"
echo ""

m -j$JOBS systemimage

echo ""
echo "[5/5] Build complete!"
echo ""

# ============================================
# Show build artifacts
# ============================================
echo "=========================================="
echo " Build Artifacts"
echo "=========================================="
echo " Output directory: $OUT_DIR_COMMON_BASE/target/product/generic_arm64/"
echo ""

ls -lh $OUT_DIR_COMMON_BASE/target/product/generic_arm64/ 2>/dev/null | grep -E "system.*img|GSI.*zip" || echo "  Looking for artifacts..."
find $OUT_DIR_COMMON_BASE/target/product/generic_arm64/ -name "system.img" 2>/dev/null | head -5
find $OUT_DIR_COMMON_BASE/target/product/generic_arm64/ -name "*GSI*" 2>/dev/null | head -5

echo ""
echo "=========================================="
echo " Post-build: Flash to Redmi K20 Pro"
echo "=========================================="
echo " 1. Download the GSI image"
echo " 2. Flash with fastboot:"
echo "     fastboot flash system system.img"
echo " 3. Reboot to bootloader, then boot the GSI:"
echo "     fastboot reboot fastboot"
echo "     fastboot --disable-verity --disable-verification flash system system.img"
echo ""
echo " Or test in Android Studio Emulator:"
echo "  https://source.android.com/docs/setup/create/system"
echo ""
echo "=========================================="
echo " MuHanOS 12 - Built by MuHan"
echo "=========================================="
