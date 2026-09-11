# MuHanOS 12 - Generic Product
#

# Inherit from generic device
$(call inherit-product, device/generic/common/generic_system.mk)

# MuHanOS overlays
DEVICE_PACKAGE_OVERLAYS += vendor/muhanos/overlay

# MuHanOS custom properties
PRODUCT_PROPERTIES += \
    ro.muhanos.version=Beta26.9.11 \
    ro.muhanos.base.version=12 \
    ro.muhanos.maintainer=MuHan \
    ro.muhanos.display.version=MuHanOS 12 Beta26.9.11

# Product name
PRODUCT_NAME := mu_hanos
PRODUCT_DEVICE := mu_hanos
PRODUCT_BRAND := MuHanOS
PRODUCT_MODEL := MuHanOS 12
PRODUCT_MANUFACTURER := MuHan

# MuHanOS description
PRODUCT_DESCRIPTION := MuHanOS 12 Beta26.9.11 by MuHan
