PACKAGECONFIG:append:dmoseley-setup[vdpau] = "--enable-vdpau, --disable-vdpau,libvdpau libxext libxrandr"

PACKAGECONFIG:append:dmoseley-setup = " drm "
PACKAGECONFIG:remove:dmoseley-setup = "lua"