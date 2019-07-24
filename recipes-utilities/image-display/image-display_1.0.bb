DESCRIPTION = "Systemd Service script to run mpv in a loop with a PNG file for demo purposes."
HOMEPAGE = "https://mender.io"
LICENSE = "Apache-2.0"

SRC_URI = " \
	file://${PN}.service \
        ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "file://demo-image-locked.png file://demo-image-unlocked.png", "file://Max.png", d)} \
	file://LICENSE \
"
LIC_FILES_CHKSUM = "file://${S}/../LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit systemd

SYSTEMD_SERVICE_${PN} = "${PN}.service"
FILES_${PN} += "${systemd_unitdir}/system/${PN}.service"
RDEPENDS_${PN} += "fbida"
LICENSE_FLAGS_WHITELIST += "commercial"

IMAGE_DISPLAY_IMAGE_FILE ?= "${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "demo-image-unlocked.png", "Max.png", d)}"

do_install() {
  install -d ${D}/${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/${PN}.service ${D}/${systemd_unitdir}/system
  install -d ${D}/${sysconfdir}/
  install -m 0644 ${WORKDIR}/*.png ${D}/${sysconfdir}/
  ln -s ${IMAGE_DISPLAY_IMAGE_FILE}  ${D}/${sysconfdir}/demo-image.png
}
