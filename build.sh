#!/bin/sh

SURGE_CONTAINER_IMAGE=ntc-registry.githost.io/kaplan2539/baumeister

CONTAINER_NAME="${CI_PROJECT_PATH}"
CONTAINER_NAME="${CONTAINER_NAME##*/}"

CONTAINER_IMAGE=${CONTAINER_IMAGE:-nextthingco/chiptainer_alpine}
CONTAINER_NAME=${CONTAINER_NAME:-alpine_armhf}

ROOTFS_URL=${ROOTFS_URL:-https://nl.alpinelinux.org/alpine/v3.5/releases/armhf/alpine-minirootfs-3.5.0-armhf.tar.gz}
QEMU_STATIC_URL=${QEMU_STATIC_URL:-http://kaplan2539.gitlab.io/baumeister/qemu-arm-static.tar.gz}

OUTPUT_DIR=$PWD/out

mkdir -p "$OUTPUT_DIR"
wget -c $ROOTFS_URL -O rootfs.tar.gz
wget -c $QEMU_STATIC_URL
docker build -t "${CONTAINER_IMAGE}" .
docker push ${CONTAINER_IMAGE}

docker create --name=${CONTAINER_NAME} $CONTAINER_IMAGE /bin/sh
docker export ${CONTAINER_NAME} |gzip -9 >"${OUTPUT_DIR}/${CONTAINER_NAME}_rootfs.tar.gz"
docker rm ${CONTAINER_NAME}

#docker run --rm -e SURGE_LOGIN=$SURGE_LOGIN -e SURGE_TOKEN=$SURGE_TOKEN -v ${OUTPUT_DIR}:/build -w /build $SURGE_CONTAINER_IMAGE /usr/bin/surge --project /build --domain chiptainer_alpine.surge.sh
