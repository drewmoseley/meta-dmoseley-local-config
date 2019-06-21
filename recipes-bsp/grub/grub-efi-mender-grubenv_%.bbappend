FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove_up-board = " file://06_bootargs_grub.cfg "
SRC_URI_append_up-board = " file://06_upboard_bootargs_grub.cfg "