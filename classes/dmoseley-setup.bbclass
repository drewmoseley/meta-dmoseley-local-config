python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-connman',            # Use connman rather than systemd-networkd; only valid for systemd based configs
    }

    for feature in d.getVar('DISTRO_FEATURES').split():
        if feature.startswith("dmoseley-"):
            if feature not in dmoseley_local_features:
                bb.fatal("%s from DISTRO_FEATURES is not a valid local feature."
                         % feature)
            d.setVar('OVERRIDES_append', ':%s' % feature)
}

IMAGE_INSTALL_append_dmoseley-connman += " connman connman-client"
