#!/bin/bash

# Jenkins build steps
ARCHS='armv7hf armel i386 amd64 aarch64'
SUITES='jessie wheezy'

rm -rf output
mkdir -p output

for ARCH in $ARCHS
do
	for SUITE in $SUITES
	do
		case "$ARCH" in
			'armv7hf')
				sed -e s~#{FROM}~resin/armv7hf-debian:$SUITE~g \
				-e s~#{SUITE}~$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'armel')
				sed -e s~#{FROM}~resin/armel-debian:$SUITE~g \
				-e s~#{SUITE}~$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'aarch64')
				sed -e s~#{FROM}~resin/aarch64-debian:$SUITE~g \
				-e s~#{SUITE}~$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'i386')
				sed -e s~#{FROM}~resin/i386-debian:$SUITE~g \
				-e s~#{SUITE}~$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'amd64')
				sed -e s~#{FROM}~resin/amd64-debian:$SUITE~g \
				-e s~#{SUITE}~$SUITE~g Dockerfile.tpl > Dockerfile
			;;
		esac

		if [ $SUITE == 'jessie' ]; then
			KMOD_VERSION='18'
		else
			KMOD_VERSION='9'
		fi

		if [ $ARCH == 'aarch64' ] && [ $SUITE == 'wheezy' ]; then
			continue
		fi

		docker build -t kmod-$ARCH-builder:$SUITE .
		docker run --rm -e ARCH=$ARCH \
						-e SUITE=$SUITE \
						-e ACCESS_KEY=$ACCESS_KEY \
						-e SECRET_KEY=$SECRET_KEY \
						-e KMOD_VERSION=$KMOD_VERSION \
						-e BUCKET_NAME=$BUCKET_NAME \
						-v `pwd`/output:/output kmod-$ARCH-builder:$SUITE bash build.sh

		# Clean up builder image after every run
		docker rmi -f kmod-$ARCH-builder:$SUITE
	done
done


