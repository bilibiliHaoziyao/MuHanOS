# MuHanOS 12 GSI - Generic System Image
# Compatible with Redmi K20 Pro and Android Studio Emulator
#

# Inherit GSI base (already sets up arm64 architecture and GSI defaults)
$(call inherit-product, device/generic/common/gsi_arm64.mk)

# MuHanOS overlays
DEVICE_PACKAGE_OVERLAYS += vendor/muhanos/overlay

# MuHanOS custom properties
PRODUCT_PROPERTIES += \
    ro.muhanos.version=Beta26.9.11 \
    ro.muhanos.base.version=12 \
    ro.muhanos.maintainer=MuHan \
    ro.muhanos.display.version=MuHanOS 12 Beta26.9.11

# Clear inherited GSI-only variables that would conflict with custom product name
PRODUCT_INSTALL_DEBUG_POLICY_TO_SYSTEM_EXT :=

# Override GSI product info with MuHanOS branding
PRODUCT_NAME := mu_hanos_gsi
# PRODUCT_DEVICE must match existing device config (generic_arm64 for GSI)
PRODUCT_DEVICE := generic_arm64
PRODUCT_BRAND := MuHanOS
PRODUCT_MODEL := MuHanOS 12 GSI
PRODUCT_MANUFACTURER := MuHan
PRODUCT_DESCRIPTION := MuHanOS 12 Beta26.9.11 GSI by MuHan

# GSI specific build flags
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false
