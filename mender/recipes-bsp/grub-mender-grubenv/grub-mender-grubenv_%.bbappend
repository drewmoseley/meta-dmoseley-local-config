FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
    file://01_splash_mender_grub.cfg;subdir=git \
    file://02_console${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','_fastboot','',d)}_grub.cfg;subdir=git \
"
