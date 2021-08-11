SUMMARY = "A customized image for running shairport-sync"
LICENSE = "MIT"

inherit core-image

IMAGE_FSTYPES:remove = " tar.bz2 ext3 sdimg.bz2 "
GLIBC_GENERATE_LOCALES="en_US.UTF-8"
IMAGE_LINGUAS="en-us"

EXTRA_IMAGE_FEATURES += "read-only-rootfs ssh-server-openssh"

IMAGE_INSTALL:append = " shairport-sync "
IMAGE_INSTALL:remove = " image-display "