FILESEXTRAPATHS:prepend:dmoseley-setup := "${THISDIR}/files:${HOME}/SyncThing/local:"

SRC_URI:append:dmoseley-setup = " file://settings file://main-wifi-first.conf file://main-ethernet-first.conf "
SRC_URI:append:dmoseley-homenetworks = " file://caribbean.config "
SRC_URI:append:dmoseley-labnetworks = " file://caribbean-Lab.config "
FILES:${PN}:append:dmoseley-setup = " /var/lib/connman/settings "
FILES:${PN}:append:dmoseley-homenetworks = " /var/lib/connman/caribbean.config "
FILES:${PN}:append:dmoseley-labnetworks = " /var/lib/connman/caribbean-Lab.config "

do_install:append:dmoseley-setup() {
	install -d -m 0755 ${D}${sysconfdir}/connman
	if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-board-farm-controller', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/main-wifi-first.conf ${D}${sysconfdir}/connman/main.conf
	else
		install -m 0644 ${WORKDIR}/main-ethernet-first.conf ${D}${sysconfdir}/connman/main.conf
	fi
	install -d -m 0755 ${D}/var/lib/connman
	install -m 0600 ${WORKDIR}/settings ${WORKDIR}/*.config ${D}/var/lib/connman/
}
