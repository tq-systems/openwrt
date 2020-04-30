#
# Copyright (C) 2020 Gregor Herburger <gregor.herburger@tq-group.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

BOARD:=tqmls
BOARDNAME:=TQ NXP Layerscape modules
KERNEL_PATCHVER:=4.19
FEATURES:=usb pcie gpio fpu ubifs ext4
SUBTARGETS:=tqmls10xxa
MAINTAINER:=Gregor Herburger <gregor.herburger@tq-group.com>

define Target/Description
	Build firmware images for NXP Layerscape based TQ boards.
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += kmod-usb3 kmod-usb-dwc3 kmod-usb-storage

$(eval $(call BuildTarget))
