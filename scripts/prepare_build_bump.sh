#!/bin/sh

PKG=$1

error()
{
	echo "$@"
	exit 1
}

check()
{
	if [ -z "$PKG" ]; then
		error "Please provide package name!"
	fi

	if [ ! -d $PWD/buildroot ]; then
		error "Please run in the same directory level as buildroot dir!"
	fi

	if [ ! -d $PWD/buildroot-dev ]; then
		error "Please run in the same directory level as buildroot-dev dir!"
	fi
}

prepare_single()
{
	DIR=build/$PKG/$1/
	mkdir -p $DIR && cd $DIR
	make O=$PWD -C ../../../buildroot BR2_EXTERNAL=$PWD/../../../buildroot-dev ${1}_defconfig
	cd -
}

prepare()
{
	prepare_single qemu_aarch64_virt_glibc
	prepare_single qemu_arm_vexpress_uclibc
	prepare_single qemu_mips32r6el_malta_glibc
	prepare_single qemu_x86_64_musl
}

main()
{
	check
	prepare
}

main
