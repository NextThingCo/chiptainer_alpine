#!/bin/sh

CONTAINER_IMAGE=${CONTAINER_IMAGE:-nextthingco/chiptainer_alpine}

CONTAINER_NAME="${CI_PROJECT_PATH}"
CONTAINER_NAME="${CONTAINER_NAME##*/}"
CONTAINER_NAME=${CONTAINER_NAME:-alpine_armhf}

ROOTFS_URL=${ROOTFS_URL:-https://nl.alpinelinux.org/alpine/v3.5/releases/armhf/alpine-minirootfs-3.5.0-armhf.tar.gz}
QEMU_STATIC_URL=${QEMU_STATIC_URL:-http://kaplan2539.gitlab.io/baumeister/qemu-arm-static.tar.gz}

OUTPUT_DIR=$PWD/out

mkdir -p "$OUTPUT_DIR"
wget -c $ROOTFS_URL -O rootfs.tar.gz
wget -c $QEMU_STATIC_URL
docker build -t "${CONTAINER_IMAGE}" .
docker push ${CONTAINER_IMAGE}

if [[ "${CI_BUILD_REF_SLUG}" == "stable" ]]; then
    docker tag ${CONTAINER_IMAGE} ${CONTAINER_IMAGE%%:*}:latest
    docker push ${CONTAINER_IMAGE%%:*}:latest
fi

docker create --name=${CONTAINER_NAME} $CONTAINER_IMAGE /bin/sh
docker export ${CONTAINER_NAME} |gzip -9 >"${OUTPUT_DIR}/${CONTAINER_NAME}_rootfs.tar.gz"
docker rm ${CONTAINER_NAME}
