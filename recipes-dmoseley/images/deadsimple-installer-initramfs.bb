# Dead simple image installer.
# This recipe builds a initramdisk based image that launches a simple
# shell for block image installation.  This can easily be loaded over
# tftp to allow network-based images to be installed without needing
# to move storage media to your development system.

DESCRIPTION = "Tiny image for installing network-accessible images onto the \
internal storage devices of embedded boards. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."
LICENSE = "MIT"

PACKAGE_INSTALL = "initramfs-live-boot-tiny packagegroup-core-boot ${VIRTUAL-RUNTIME_base-utils} ${VIRTUAL-RUNTIME_dev_manager} base-passwd ${ROOTFS_BOOTSTRAP_INSTALL} lighttpd"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "deadsimple-installer-initramfs"
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

inherit core-image

IMAGE_ROOTFS_SIZE = "1024"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

INITRAMFS_MAXSIZE = "256000"

BAD_RECOMMENDATIONS += "busybox-syslog"

QB_KERNEL_CMDLINE_APPEND += "debugshell=3 init=/bin/busybox sh init"