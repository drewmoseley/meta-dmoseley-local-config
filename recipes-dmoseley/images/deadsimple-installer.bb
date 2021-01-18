DESCRIPTION = "Tiny image for installing network-accessible images onto the \
internal storage devices of embedded boards."
LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE = "1024"
IMAGE_ROOTFS_EXTRA_SPACE = "0"
IMAGE_INSTALL_append = " lighttpd udev "
