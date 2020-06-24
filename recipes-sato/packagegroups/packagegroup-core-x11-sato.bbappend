# Clear NETWORK_MANAGER by default
NETWORK_MANAGER_dmoseley-setup = ""
NETWORK_MANAGER_dmoseley-systemd = "systemd"
NETWORK_MANAGER_dmoseley-connman = "connman-gnome"
NETWORK_MANAGER_dmoseley-networkmanager = "networkmanager"

# Extra multimedia stuff
RDEPENDS_${PN}_append_dmoseley-setup = " mpv vlc "
