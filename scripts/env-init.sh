#!/bin/sh

if [ -z $1 ]; then
    echo 'Error: no package name given!'
    return 1
fi

if [ ! -d $PWD/buildroot ]; then
    echo "Please run in the same directory level as buildroot dir!"
    return 1
fi

if [ ! -d $PWD/buildroot-dev ]; then
    echo "Please run in the same directory level as buildroot-dev dir!"
    return 1
fi

export BR_BUILD_PKG=$1
export BR_BUILD_BASE_DIR=$PWD
export BR_BUILD_BUILDROOT_DIR=${BR_BUILD_BASE_DIR}/buildroot
export BR_BUILD_BUILDROOT_DEV_DIR=${BR_BUILD_BASE_DIR}/buildroot-dev
export BR_BUILD_PATCHES_DIR=${BR_BUILD_BUILDROOT_DIR}/patches/${BR_BUILD_PKG}
