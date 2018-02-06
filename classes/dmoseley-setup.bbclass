python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-systemd',            # Use systemd
        'dmoseley-networkd',           # Use systemd-networkd
        'dmoseley-networkmanager',     # Use networkmanager
        'dmoseley-connman',            # Use connman
        'dmoseley-wifi',               # Use wifi and install device firmware blobs
    }

    for feature in d.getVar('DISTRO_FEATURES', True).split():
        if feature.startswith("dmoseley-"):
            if feature not in dmoseley_local_features:
                bb.fatal("%s from DISTRO_FEATURES is not a valid local feature."
                         % feature)
            d.setVar('OVERRIDES_append', ':%s' % feature)

    if bb.utils.contains('DISTRO_FEATURES', 'dmoseley-connman', True, False, d) and \
       not bb.utils.contains('DISTRO_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building connman without systemd is not supported.")

    if bb.utils.contains('DISTRO_FEATURES', 'dmoseley-connman', True, False, d) and \
       bb.utils.contains('DISTRO_FEATURES', 'dmoseley-networkd', True, False, d):
        bb.fatal("Building connman and system-networkd together is not supported.")

    if bb.utils.contains('DISTRO_FEATURES', 'dmoseley-connman', True, False, d) and \
       bb.utils.contains('DISTRO_FEATURES', 'dmoseley-networkmanager', True, False, d):
        bb.fatal("Building connman and networkmanager together is not supported.")

    if bb.utils.contains('DISTRO_FEATURES', 'dmoseley-networkd', True, False, d) and \
       bb.utils.contains('DISTRO_FEATURES', 'dmoseley-networkmanager', True, False, d):
        bb.fatal("Building system-networkd and networkmanager together is not supported.")
}

IMAGE_INSTALL_append_dmoseley-connman += " connman connman-client"
IMAGE_INSTALL_append_dmoseley-networkmanager += " networkmanager networkmanager-nmtui"

DISTRO_FEATURES_append_dmoseley-wifi += " wifi"
IMAGE_INSTALL_append_dmoseley-wifi += " \
    iw wpa-supplicant \
    ${@bb.utils.contains('MACHINE', 'beaglebone', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'chip', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi-cm', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi0-wifi', 'linux-firmware-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi2', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi3', 'linux-firmware-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'udooneo', 'linux-firmware-wl18xx', '', d)} \
"

# Explicitly remove wifi from qemu buids
DISTRO_FEATURES_remove_vexpress-qemu += " wifi"
DISTRO_FEATURES_remove_vexpress-qemu-flash += " wifi"
IMAGE_INSTALL_remove_vexpress-qemu += " iw wpa-supplicant"
IMAGE_INSTALL_remove_vexpress-qemu-flash += " iw wpa-supplicant"
