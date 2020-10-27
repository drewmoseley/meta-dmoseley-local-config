SUMMARY = "A customized image for running Octoprint"
LICENSE = "MIT"

inherit core-image

IMAGE_INSTALL_append = " octoprint "
EXTRA_IMAGE_FEATURES_remove = "debug-tweaks"
IMAGE_FSTYPES_remove = " tar.bz2 ext3 sdimg.bz2 "
GLIBC_GENERATE_LOCALES="en_US.UTF-8"
IMAGE_LINGUAS="en-us"

EXTRA_IMAGE_FEATURES += "read-only-rootfs ssh-server-openssh"

RDEPENDS_${PN} += "octoprint python3-octoprint-themeify python3-octoprint-bedlevelvisualizer python3-octoprint-autoterminalinput"

ROOTFS_POSTPROCESS_COMMAND_append = " disable_octoprint_user_password;"
disable_octoprint_user_password() {
    sed -i -e 's@octoprint\:\!\:\(.*\)@octoprint\:\*\:\1@' ${IMAGE_ROOTFS}${sysconfdir}/shadow
}
