
python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-systemd',            # Use systemd
        'dmoseley-networkd',           # Use systemd-networkd
        'dmoseley-networkmanager',     # Use networkmanager
        'dmoseley-connman',            # Use connman
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
