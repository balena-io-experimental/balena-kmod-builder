#!/bin/bash

set -o errexit

mkdir -p /out/kmod-$KMOD_VERSION
cd /kmod-$KMOD_VERSION

./configure \
	--sysconfdir=/etc \
	--with-xz \
	--with-zlib \
	--disable-gtk-doc

make
make -C /kmod-$KMOD_VERSION DESTDIR=/out/kmod-$KMOD_VERSION install

tar -cvzf kmod-$KMOD_VERSION-$ARCH-$SUITE.tar.gz /out/kmod-$KMOD_VERSION/*

# Upload to S3 (using AWS CLI)
printf "$ACCESS_KEY\n$SECRET_KEY\n$REGION_NAME\n\n" | aws configure
aws s3 cp kmod-$KMOD_VERSION-$ARCH-$SUITE.tar.gz s3://$BUCKET_NAME/kmod/v$KMOD_VERSION/
