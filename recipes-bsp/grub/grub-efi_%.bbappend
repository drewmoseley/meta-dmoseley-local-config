FILESEXTRAPATHS_prepend_dmoseley-setup := "${THISDIR}/files:"
inherit ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-setup', 'dmoseley-grub-efi-impl', '', d)}
