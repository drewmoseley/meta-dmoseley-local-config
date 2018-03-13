DESCRIPTION = "Systemd Service script to run mpv in a loop with a PNG file for demo purposes."
HOMEPAGE = "https://mender.io"
LICENSE = "Apache-2.0"

SRC_URI = " \
	file://${PN}.service \
	file://demo-image-locked.png \
	file://demo-image-unlocked.png \
	file://LICENSE \
"
LIC_FILES_CHKSUM = "file://${S}/../LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit systemd

SYSTEMD_SERVICE_${PN} = "${PN}.service"
FILES_${PN} += "${systemd_unitdir}/system/${PN}.service"
RDEPENDS_${PN} = "mpv"
LICENSE_FLAGS_WHITELIST += "commercial"

IMAGE_DISPLAY_IMAGE_FILE ?= "demo-image-unlocked.png"

do_install() {
  install -d ${D}/${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/${PN}.service ${D}/${systemd_unitdir}/system
  install -d ${D}/${sysconfdir}/
  install -m 0644 ${WORKDIR}/demo-image-unlocked.png ${D}/${sysconfdir}/
  install -m 0644 ${WORKDIR}/demo-image-locked.png ${D}/${sysconfdir}/
  ln -s ${IMAGE_DISPLAY_IMAGE_FILE}  ${D}/${sysconfdir}/demo-image.png
}
