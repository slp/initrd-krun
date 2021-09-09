#!/bin/sh

../libkrunfw/linux-5.10.10/usr/gen_init_cpio cpio_list | gzip -9 -n > initrd.gz

#PSIZE=1695744
PSIZE=2129920
FSIZE=`stat --format "%s" initrd.gz`

if [ $FSIZE -gt $PSIZE ]; then
	echo "The initrd.gz file size is too big"
fi

let padding=$PSIZE-$FSIZE

dd if=/dev/zero of=initrd.gz bs=1 seek=$FSIZE count=$padding

