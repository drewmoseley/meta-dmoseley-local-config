# Clear NETWORK_MANAGER by default
NETWORK_MANAGER:dmoseley-setup = ""
NETWORK_MANAGER:dmoseley-systemd = "systemd"
NETWORK_MANAGER:dmoseley-connman = "connman-gnome"
NETWORK_MANAGER:dmoseley-networkmanager = "networkmanager"

# Extra multimedia stuff
RDEPENDS:${PN}:append:dmoseley-setup = " mpv vlc "
