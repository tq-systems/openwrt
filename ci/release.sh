#!/bin/bash
#
# File:        release.sh
# Copyright (C) 2014 - 2020 TQ Systems GmbH
# @author Michael Krummsdorf <michael.krummsdorf@tq-group.com>
# @author Gregor Herburger <gregor.herburger@tq-group.com>
#
# Description: A utility script that builds an packages the BSP.
#
#              Use release.sh to perform a complete build and create archives of
#              images, source tarballs, dev packages and BSP
#
# License:     GPLv2
#
###############################################################################
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
###############################################################################

# DEBUGGING
#set -e
#set -C # noclobber
set -o pipefail

readonly PROGRAM="$(basename ${0})"
readonly SCRIPT_LIBDIR="$(dirname ${0})"

DL_DIR="/mnt/src/openwrt"

# needed for do_query_release_type
PLATFORM_RELEASE_STAMP=
PLATFORM_VERSION_PART=
PLATFORM_PLATFORM_PART=

source "ci/tools_lib_git.sh"

# RETURN VALUES/EXIT STATUS CODES
readonly E_BAD_OPTION=254
readonly E_UNKNOWN=255

function usage () {
    echo "Usage is as follows:"
    echo
    echo "$PROGRAM <--usage|--help|-?>"
    echo "    Prints this usage output and exits."
    echo "$PROGRAM [--platform <name>] [--stamp <name>] [--use-git] [--debug] [--license]"
    echo "    compile everything and create archives if under git."
    echo " --platform <name>"
    echo "     assign platform name from config stage: make <platform>_defconfig"
    echo " --stamp <name>"
    echo "    compile everything and create archives from <stamp> if under git."
    echo "--debug"
    echo "    omit cleaning before collecting data."
    echo
}

function main () {
	local MYPWD=
	local DO_DEBUG="no"
	local HAVE_GIT="0"
	local EXTRACT_LICENSES="0"
	local ret=0
	local PLATFORM
	local PLATFORM_NAME
	local LOGFILE

	# Process command-line arguments.
	while test $# -gt 0; do
	    case $1 in
		--platform )
		    shift
		    PLATFORM_NAME="$1"
		    shift
		    ;;

		--stamp )
		    shift
		    STAMP="$1"
		    shift
		    ;;

		--debug )
		    shift
		    DO_DEBUG="yes"
		    ;;

		-? | --usage | --help )
		    usage
		    exit
		    ;;

		-* )
		    echo "Unrecognized option: $1" >&2
		    usage
		    exit $E_BAD_OPTION
		    ;;

		* )
		    break
		    ;;
	    esac
	done

	MYPWD=$(pwd)
	PLATFORM=${PLATFORM_NAME}
	OUTPUT_DIR=dist
	LOGFILE=make.log
	PKG_SRC_DIR=$OUTPUT_DIR/src
	BIN_DIR=bin/targets/tqmls/tqmls10xxa

	[ check_git ] && HAVE_GIT="1"

	do_query_release_type "noversion" ${PLATFORM} ${STAMP}
	[ "${?}" -ne "0" ] && return ${E_UNKNOWN}
	STAMPFILE=${PLATFORM_PLATFORM_PART}.build.SRC.${PLATFORM_VERSION_PART}.info

	readonly PKG_SRC_ARCHIVE=${OUTPUT_DIR}/${PLATFORM_PLATFORM_PART}.Packages.SRC.${PLATFORM_VERSION_PART}.tar.gz
	readonly BSP_SRC_NAME=${PLATFORM_PLATFORM_PART}.SRC.${PLATFORM_VERSION_PART}
	readonly BSP_SRC_ARCHIVE=${OUTPUT_DIR}/${PLATFORM_PLATFORM_PART}.SRC.${PLATFORM_VERSION_PART}.tar
	readonly BSP_BIN_ARCHIVE=${OUTPUT_DIR}/${PLATFORM_PLATFORM_PART}.BIN.${PLATFORM_VERSION_PART}.tar.gz
	readonly BSP_MD5FILE=${PLATFORM_PLATFORM_PART}.md5sum.${PLATFORM_VERSION_PART}

	if [ "${DO_DEBUG}" != "yes" ]; then
		echo "DO_DEBUG: ${DO_DEBUG}"
		rm -f ${LOGFILE}
		make clean
	fi

	make world V=sc | tee -a ${LOGFILE}
	ret=$?
	if [ $ret -ne 0 ]; then
		echo "build error, see log.";
		exit $E_UNKNOWN;
	fi

	if [ "${HAVE_GIT}" -ne "0" ]; then
		git log -1 > $BIN_DIR/${STAMPFILE}
	fi

	#generate list of source files
	make download V=s -d | grep "Considering target file '$DL_DIR" |\
		sed -n "s/^.*'\(.*\)'.*$/\1/ p" > .tmp_srclist
	#"''"
	ret=$?
	if [ $ret -ne 0 ]; then
		echo "extracting src files failed.";
		rm -f .tmp_srclist
		exit $E_UNKNOWN;
	fi

	mkdir -p $PKG_SRC_DIR

	cat .tmp_srclist | while read line
	do
		cp $line $PKG_SRC_DIR
	done

	tar -cvzf ${PKG_SRC_ARCHIVE} -C $PKG_SRC_DIR .
	rm -f .tmp_srclist
	rm -r $PKG_SRC_DIR

	if [ "${HAVE_GIT}" -ne "0" ]; then
		echo "create archive ${PLATFORM_BSP_SRC_ARCHIVE} from ${RELEASE_STAMP} ...";
		$MYPWD/ci/git-archive-all.sh --format tar.gz --commit ${RELEASE_STAMP} ${BSP_SRC_ARCHIVE};
		ret=$?
		if [ $ret -ne 0 ]; then
			echo "git archiving failed, see log.";
			exit $E_UNKNOWN;
		fi
	fi

        # remove senseless images created by openwrt before archiving
        for file in ${BIN_DIR}/*;
        do
                if [[ $file == *openwrt-tqmls-tqmls10xxa-*-ext4-root.ubi ]] ||
                   [[ $file == *openwrt-tqmls-tqmls10xxa-*-ubifs-firmware_sdcard.img ]] ||
                   [[ $file == *openwrt-tqmls-tqmls10xxa-*-ext4-firmware_qspi.bin ]]; then
                        echo "Deleting $file";
                        rm -f $file;
                fi
        done

	tar -cvzf ${BSP_BIN_ARCHIVE} -C $BIN_DIR .

	exit 0
}

main $@
