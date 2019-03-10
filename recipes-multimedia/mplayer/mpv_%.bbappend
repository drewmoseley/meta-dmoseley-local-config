PACKAGECONFIG[vdpau] = "--enable-vdpau, --disable-vdpau,libvdpau libxext libxrandr"

PACKAGECONFIG_append = " drm vdpau "
PACKAGECONFIG_remove = "lua"