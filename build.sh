#!/bin/bash

set -o errexit
set -o pipefail

PACKAGE_NAME=kmod-$KMOD_VERSION-resin

set -o errexit

cd /kmod-$KMOD_VERSION/debian
sed -i s~"CONFFLAGS = --sysconfdir=/etc --bindir=/bin"~"CONFFLAGS = --sysconfdir=/etc --bindir=/bin --with-xz --with-zlib"~g rules
cd ..
debuild -us -uc

cp /*.deb /output/