PACKAGECONFIG_append_dmoseley-setup[vdpau] = "--enable-vdpau, --disable-vdpau,libvdpau libxext libxrandr"

PACKAGECONFIG_append_dmoseley-setup = " drm "
PACKAGECONFIG_remove_dmoseley-setup = "lua"