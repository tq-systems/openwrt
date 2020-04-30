# Copyright 2018 NXP
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
define Device/tqmls1043a-mbls10xxa
  KERNEL_PATCHVER := 4.19
  KERNEL_NAME := Image
  KERNEL_SUFFIX := -kernel.itb
  KERNEL_INSTALL := 1
  FDT_LOADADDR = 0x90000000
  FILESYSTEMS := ext4 ubifs
  DEVICE_TITLE := TQ TQMLS1043A Module on MBLS10xxA
  DEVICE_PACKAGES += \
    u-boot-tq-tqmls1043a-mbls10xxa-qspi \
    u-boot-tq-tqmls1043a-mbls10xxa-esdhc \
    layerscape-fman-ls1043ardb
  DEVICE_DESCRIPTION = \
    Build images for TQ LS1043 boards.
  DEVICE_DTS = freescale/fsl-tqmls1043a-mbls10xxa
  DEVICE_DTS_DIR = $(LINUX_DIR)/arch/arm64/boot/dts
  KERNEL = kernel-bin
  MKUBIFS_OPTS := -m 1 -e 65408 -c 640
IMAGES := general firmware_sdcard.img firmware_qspi.bin root.ubi
  IMAGE/general := ls-install-kernel | ls-install-dtb
  IMAGE/firmware_sdcard.img := \
    ls-clean | \
    ls-append-sdhead $(1) | pad-to 4K | \
    ls-append $(1)-esdhc-uboot.bin | pad-to 9M | \
    ls-append ls1043ardb-fman.bin | pad-to 16M | \
    boot-part $(1) | ls-append $(1).boot | pad-to 48M | \
    append-rootfs | pad-rootfs |check-size 536870912 |
  IMAGE/firmware_qspi.bin := \
    ls-clean | \
    ls-append $(1)-qspi-uboot.bin | pad-to 896K | \
    ls-append ls1043ardb-fman.bin | pad-to 960K | \
    ls-append fsl-$(1).dtb |  pad-to 1M | \
    ls-append Image | pad-to 24M | \
    append-ubi | pad-to 64M |
  IMAGE/root.ubi := append-ubi
endef
TARGET_DEVICES += tqmls1043a-mbls10xxa

define Device/tqmls1046a-mbls10xxa
  KERNEL_PATCHVER := 4.19
  KERNEL_NAME := Image
  KERNEL_SUFFIX := -kernel.itb
  KERNEL_INSTALL := 1
  FDT_LOADADDR = 0x90000000
  FILESYSTEMS := ext4 ubifs
  DEVICE_TITLE := TQ TQMLS1046A Module on MBLS10xxA
  DEVICE_PACKAGES += \
    u-boot-tq-tqmls1046a-mbls10xxa-qspi \
    u-boot-tq-tqmls1046a-mbls10xxa-esdhc \
    layerscape-fman-ls1046ardb
  DEVICE_DESCRIPTION = \
    Build images for TQ LS1046 boards.
  DEVICE_DTS = freescale/fsl-tqmls1046a-mbls10xxa
  DEVICE_DTS_DIR = $(LINUX_DIR)/arch/arm64/boot/dts
  KERNEL = kernel-bin
  MKUBIFS_OPTS := -m 1 -e 65408 -c 640
IMAGES := general firmware_sdcard.img firmware_qspi.bin root.ubi
  IMAGE/general := ls-install-kernel | ls-install-dtb
  IMAGE/firmware_sdcard.img := \
    ls-clean | \
    ls-append-sdhead $(1) | pad-to 4K | \
    ls-append $(1)-esdhc-uboot.bin | pad-to 9M | \
    ls-append ls1046ardb-fman.bin | pad-to 16M | \
    boot-part $(1) | ls-append $(1).boot | pad-to 48M | \
    append-rootfs | pad-rootfs |check-size 536870912 |
  IMAGE/firmware_qspi.bin := \
    ls-clean | \
    ls-append $(1)-qspi-uboot.bin | pad-to 896K | \
    ls-append ls1046ardb-fman.bin | pad-to 960K | \
    ls-append fsl-$(1).dtb |  pad-to 1M | \
    ls-append Image | pad-to 24M | \
    append-ubi | pad-to 64M |
  IMAGE/root.ubi := append-ubi
endef
TARGET_DEVICES += tqmls1046a-mbls10xxa
