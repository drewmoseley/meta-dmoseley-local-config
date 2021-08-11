SUMMARY = "A customized image for running Octoprint"
LICENSE = "MIT"

inherit core-image

IMAGE_FSTYPES:remove = " tar.bz2 ext3 sdimg.bz2 "
GLIBC_GENERATE_LOCALES="en_US.UTF-8"
IMAGE_LINGUAS="en-us"

EXTRA_IMAGE_FEATURES += "read-only-rootfs ssh-server-openssh"

IMAGE_INSTALL:append = " octoprint picocom "
IMAGE_INSTALL:remove = " image-display "