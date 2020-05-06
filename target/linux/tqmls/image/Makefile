#
# Copyright (C) 2016 Jiang Yutang <jiangyutang1978@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

LS_SD_ROOTFSPART_OFFSET = 64
LS_SD_IMAGE_SIZE = $(shell echo $$((($(LS_SD_ROOTFSPART_OFFSET) + \
	$(CONFIG_TARGET_ROOTFS_PARTSIZE)) * 1024 * 1024)))

define Device/Default
  FAT32_BLOCKS:=32708
  BLOCKSIZE:=65536
  PAGESIZE:=1
endef

define Build/boot-part
	rm -f $@.boot
	mkfs.fat $@.boot -C 32708
	mcopy -i $@.boot $(DEVICE_DTS_DIR)/$(DEVICE_DTS).dtb ::$(notdir $(DEVICE_DTS)).dtb
	mcopy -i $@.boot $(IMAGE_KERNEL) ::linuximage
	$(INSTALL_DATA) $@.boot $(STAGING_DIR_IMAGE)/$(1).boot
endef

define Build/ls-install-dtb
	$(INSTALL_DATA) \
		$(DEVICE_DTS_DIR)/$(DEVICE_DTS).dtb \
		$(BIN_DIR)/$(notdir $(DEVICE_DTS)).dtb;
	$(INSTALL_DATA) \
		$(DEVICE_DTS_DIR)/$(DEVICE_DTS).dtb \
		$(STAGING_DIR_IMAGE)/$(notdir $(DEVICE_DTS)).dtb
endef

define Build/ls-install-kernel
	$(INSTALL_DATA) \
		$(IMAGE_KERNEL) \
		$(BIN_DIR)/Image;
	$(INSTALL_DATA) \
		$(IMAGE_KERNEL) \
		$(STAGING_DIR_IMAGE)/Image;
endef

define Build/ls-install-fman
	$(INSTALL_DATA) \
		$(STAGING_DIR_IMAGE)/$(1) \
		$(BIN_DIR)/$1
endef

define Build/ls-clean
	rm -f $@
endef

define Build/ls-append
	dd if=$(STAGING_DIR_IMAGE)/$(1) >> $@
endef

define Build/ls-append-dtb
	$(call Image/BuildDTB,$(DTS_DIR)/$(1).dts,$(DTS_DIR)/$(1).dtb)
	dd if=$(DTS_DIR)/$(1).dtb >> $@
endef

define Build/ls-append-sdhead
	./gen_sdcard_head_img.sh $(STAGING_DIR_IMAGE)/$(1)-sdcard-head.img \
		$(LS_SD_ROOTFSPART_OFFSET) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
	dd if=$(STAGING_DIR_IMAGE)/$(1)-sdcard-head.img >> $@
endef

ifeq ($(SUBTARGET),tqmls10xxa)
	include tqmls10xxa.mk
endif

$(eval $(call BuildImage))
