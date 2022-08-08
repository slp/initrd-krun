#!/bin/sh

if [ "$#" != 2 ]; then
	echo "Usage: $0 LIBKRUN_PATH LIBKRUNFW_PATH"
	exit 1
fi

LIBKRUN_PATH=$1
LIBKRUNFW_PATH=$2

if [ ! -e "${LIBKRUN_PATH}/init/init" ]; then
	echo "Can't find libkrun's init at ${LIBKRUN_PATH}/init/init"
	exit 1
fi

if [ ! -e ${LIBKRUNFW_PATH}/linux-*/usr/gen_init_cpio ]; then
	echo "Can't find gen_init_cpio at ${LIBKRUNFW_PATH}/linux-*/usr/gen_init_cpio"
	exit 1
fi

cp ${LIBKRUN_PATH}/init/init /tmp/init
strip /tmp/init

cp prebuilts/cryptsetup.static /tmp/cryptsetup

${LIBKRUNFW_PATH}/linux-*/usr/gen_init_cpio cpio_list | gzip -9 -n > initrd.gz

PSIZE=2129920
FSIZE=`stat --format "%s" initrd.gz`

if [ $FSIZE -gt $PSIZE ]; then
	echo "The initrd.gz file size is too big"
fi

let padding=$PSIZE-$FSIZE

dd if=/dev/zero of=initrd.gz bs=1 seek=$FSIZE count=$padding

