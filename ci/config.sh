#!/bin/bash
#
# File:        config.sh
# Copyright (C) 2020 TQ Systems GmbH
# @author Gregor Herburger <gregor.herburger@tq-group.com>

DL_DIR="/mnt/src/openwrt"

cp ci/tqmls10xx_defconfig .config
if [ -d $DL_DIR ];then
	echo "CONFIG_DOWNLOAD_FOLDER=\"$DL_DIR\"" >> .config
fi
