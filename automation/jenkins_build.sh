#!/bin/bash

# Jenkins build steps
ARCHS='armv6hf armv7hf armel i386 amd64 aarch64'
SUITES='jessie wheezy'

for ARCH in $ARCHS
do
	for SUITE in $SUITES
	do
		case "$ARCH" in
			'armv6hf')
				sed -e s~#{FROM}~resin/rpi-raspbian:$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'armv7hf')
				sed -e s~#{FROM}~resin/armv7hf-debian:$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'armel')
				sed -e s~#{FROM}~resin/armel-debian:$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'aarch64')
				sed -e s~#{FROM}~resin/aarch64-debian:$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'i386')
				sed -e s~#{FROM}~resin/i386-debian:$SUITE~g Dockerfile.tpl > Dockerfile
			;;
			'amd64')
				sed -e s~#{FROM}~resin/amd64-alpine:$SUITE~g Dockerfile.tpl > Dockerfile
			;;
		esac

		docker build -t kmod-$ARCH-builder .
		docker run --rm -e ARCH=$ARCH \
						-e SUITE=$SUITE \
						-e ACCESS_KEY=$ACCESS_KEY \
						-e SECRET_KEY=$SECRET_KEY \
						-e BUCKET_NAME=$BUCKET_NAME kmod-$ARCH-builder bash build.sh

		# Clean up builder image after every run
		docker rmi -f kmod-$ARCH-builder
	done
done


