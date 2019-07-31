FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://01_splash_mender_grub.cfg;subdir=git \
    file://02_console${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','_fastboot','',d)}_grub.cfg;subdir=git \
"

SRC_URI_remove_up-board = " file://06_bootargs_grub.cfg "
SRC_URI_append_up-board = " file://06_upboard_bootargs_grub.cfg "

# Process fastboot
SRC_URI_remove_dmoseley-fastboot = " \
    file://06_bootargs_grub.cfg \
    file://06_upboard_bootargs_grub.cfg \
"

python () {
    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-fastboot', True, False, d):
        if "up-board" in d.getVar("MACHINEOVERRIDES").split(":"):
            d.setVar('SRC_URI_append', 'file://06_upboard_quiet_bootargs_grub.cfg')
        else:
            d.setVar('SRC_URI_append', 'file://06_quiet_bootargs_grub.cfg')
}
