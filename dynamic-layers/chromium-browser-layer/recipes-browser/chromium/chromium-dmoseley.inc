GN_ARGS:append = " \
   ${@bb.utils.contains_any('MACHINE','colibri-imx6 apalis-imx6','use_system_minigbm=false use_wayland_gbm=false','',d)} \
   ${@bb.utils.contains_any('MACHINE','verdin-imx8mm verdin-imx8mp apalis-imx8 colibri-imx8x','use_wayland_gbm=false','',d)} \
"

do_install:append() {
    # Remove ANGLE libraries to allow proper GPU acceleration
    case ${MACHINE} in
         colibri-imx6 | apalis-imx6 | verdin-imx8mm | verdin-imx8mp | apalis-imx8 | colibri-imx8x )
             rm -f ${D}${libdir}/chromium/libEGL.so
             rm -f ${D}${libdir}/chromium/libGLESv2.so
             ;;
    esac
}
