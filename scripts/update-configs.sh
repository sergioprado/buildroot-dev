#!/bin/sh

set -e

BASE_DIR=$PWD
BR_DIR=$BASE_DIR/buildroot
BR_DEV_DIR=$BASE_DIR/buildroot-dev
WORK_DIR=$BASE_DIR/workdir

error()
{
    echo "$@"
    exit 1
}

check()
{
    if [ ! -d ${BR_DIR} ]; then
        error "Please run in the same directory level as buildroot dir!"
    fi

    if [ ! -d ${BR_DEV_DIR} ]; then
        error "Please run in the same directory level as buildroot-dev dir!"
    fi
}

update_configs_single()
{
    CONFIG_FILE=${1}
    CONFIG_NAME=${2}

    OUT_DIR=${WORK_DIR}/${CONFIG_FILE}
    MAKE_PARAMS="O=${OUT_DIR} -C ${BR_DIR}"

    mkdir -p ${OUT_DIR} && cd ${OUT_DIR}

    make ${MAKE_PARAMS} ${CONFIG_NAME}_defconfig
    make ${MAKE_PARAMS} menuconfig # call menuconfig to manually change to bootlin toolchains
    make ${MAKE_PARAMS} savedefconfig

    cd ${BR_DIR}
    cp -v configs/${CONFIG_NAME}_defconfig ${BR_DEV_DIR}/configs/${CONFIG_FILE}
    git checkout configs/${CONFIG_NAME}_defconfig
}

update_configs()
{
    
    for config_file in $(ls -1 ${BR_DEV_DIR}/configs); do
        config_name=${config_file%_*_defconfig}
        update_configs_single ${config_file} ${config_name}
    done
    cd ${BASE_DIR} && rm -Rf ${WORK_DIR}
}

main()
{
    check
    update_configs
}

main
