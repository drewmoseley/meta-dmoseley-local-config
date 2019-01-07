# Clear NETWORK_MANAGER by default
NETWORK_MANAGER = ""
NETWORK_MANAGER_dmoseley-systemd = "systemd"
NETWORK_MANAGER_dmoseley-connman = "connman-gnome"
NETWORK_MANAGER_dmoseley-network-manager = "networkmanager"

# Extra multimedia stuff
RDEPENDS_${PN}_rpi += "mpv vlc image-display"
RDEPENDS_${PN}_colibri-imx7-mender += "mpv vlc image-display"
RDEPENDS_${PN}_colibri-imx7 += "mpv vlc image-display"
