# CHIPtainer: Alpine

- generate Docker container image "nextthingco/chiptainer_alpine" based on alpine armhf mini rootfs
- add custom built [qemu-arm-static v2.7](http://kaplan2539.gitlab.io/baumeister/qemu-arm-static.tar.gz)
- resin patches enable Qemu to run even on Linux kernels w/o the binfmt module
- makes it easy to build ARM Docker container images on x86 systems

# TODO:
- move qemu-arm-static source from resin into this repository -> no external dependencies ?
- build qemu-arm-static as part of this build ?
- consider creating seperate project for qemu-arm-static v2.7


