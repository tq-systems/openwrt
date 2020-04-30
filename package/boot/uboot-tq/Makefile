#
# Copyright (C) 2020 Gregor Herburger gregor.herburger@tq-group.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-tq
PKG_VERSION:=2018.07
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/tq-systems/u-boot-tqmaxx.git
PKG_SOURCE_VERSION:=cb084ac10a4ab8345c48f829462e6077c4587d60
PKG_MIRROR_HASH:=skip
PKG_BUILD_DEPENDS:=tfa-layerscape/host

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=tqmls
  BUILD_SUBTARGET:=tqmls10xxa
  BUILD_DEVICES:=$(1)
  ENV_SIZE:=0x2000
endef

define U-Boot/tqmls1043a-mbls10xxa-qspi
  NAME:=TQMLS1043A qspi boot
  UBOOT_CONFIG:=tqmls1043a_mbls10xxa_qspi
  UBOOT_IMAGE:=u-boot-pbl.bin
endef

define U-Boot/tqmls1043a-mbls10xxa-esdhc
  NAME:=TQMLS1043A emmc boot
  UBOOT_CONFIG:=tqmls1043a_mbls10xxa_esdhc
  UBOOT_IMAGE:=u-boot-with-spl-pbl.bin
endef

define U-Boot/tqmls1046a-mbls10xxa-qspi
  NAME:=TQMLS1046A qspi boot
  UBOOT_CONFIG:=tqmls1046a_mbls10xxa_qspi
  UBOOT_IMAGE:=u-boot-pbl.bin
endef

define U-Boot/tqmls1046a-mbls10xxa-esdhc
  NAME:=TQMLS10436 emmc boot
  UBOOT_CONFIG:=tqmls1046a_mbls10xxa_esdhc
  UBOOT_IMAGE:=u-boot-with-spl-pbl.bin
endef

define Package/u-boot-tqmls1046a-mbls10xxa-qspi/config
	source "$(SOURCE)/Config.in"
endef

UBOOT_TARGETS := tqmls1043a-mbls10xxa-esdhc \
		 tqmls1043a-mbls10xxa-qspi \
		 tqmls1046a-mbls10xxa-esdhc \
		 tqmls1046a-mbls10xxa-qspi

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE);
	$(if $(findstring -qspi,$(BUILD_VARIANT)), \
		($(STAGING_DIR_HOST)/bin/tfa-byte-swap $(PKG_BUILD_DIR)/$(UBOOT_IMAGE))\
	)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(UBOOT_IMAGE) \
		$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-uboot.bin
endef

define Build/Configure
	$(if $(findstring -tqmls1043a,$(BUILD_VARIANT)), \
		echo "CONFIG_$(call qstrip,$(CONFIG_UBOOT_RCW_CONFIG_TQMLS1043A))=y" >> $(PKG_BUILD_DIR)/configs/$(UBOOT_CONFIG)_config
	)
	$(if $(findstring -tqmls1046a,$(BUILD_VARIANT)), \
		echo "CONFIG_$(call qstrip,$(CONFIG_UBOOT_RCW_CONFIG_TQMLS1046A))=y" >> $(PKG_BUILD_DIR)/configs/$(UBOOT_CONFIG)_config
	)
	$(call Build/Configure/U-Boot)
endef

$(eval $(call BuildPackage/U-Boot))
