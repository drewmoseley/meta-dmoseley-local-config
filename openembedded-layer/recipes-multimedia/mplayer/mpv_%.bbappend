PACKAGECONFIG[vdpau] = "--enable-vdpau, --disable-vdpau,libvdpau libxext libxrandr"

PACKAGECONFIG_append = " drm "
PACKAGECONFIG_remove = "lua"