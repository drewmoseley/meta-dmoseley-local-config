SUMMARY = "A customized image for running Octoprint"
LICENSE = "MIT"

inherit core-image

EXTRA_IMAGE_FEATURES_remove = "debug-tweaks"
IMAGE_FSTYPES_remove = " tar.bz2 ext3 sdimg.bz2 "
GLIBC_GENERATE_LOCALES="en_US.UTF-8"
IMAGE_LINGUAS="en-us"

EXTRA_IMAGE_FEATURES += "read-only-rootfs ssh-server-openssh"

IMAGE_INSTALL_append = " octoprint "
