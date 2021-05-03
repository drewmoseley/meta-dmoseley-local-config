#
# Setup lighttpd for dead simple image installer
#
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += "lighttpd-module-cgi \
                   lighttpd-module-fastcgi \
                   php-cgi \
                   bash"

SRC_URI += "file://deadsimple-installer.sh \
            git://github.com/ColasNahaboo/cgibashopts;protocol=https;destsuffix=cgibashopts \
            file://index.html.lighttpd.deadsimple-installer \
            file://upload.php \
            file://lighttpd-deadsimple-installer.conf"

SRCREV_pn-lighttpd = "4d80679785d3ecf7b06548ba334aa63d6ef01d88"

do_install_append() {
	install -m 0644 ${WORKDIR}/index.html.lighttpd.deadsimple-installer ${D}/www/pages/index.html

    install -m 0755 ${WORKDIR}/deadsimple-installer.sh ${D}/www/pages/deadsimple-installer.sh
    install -m 0644 ${WORKDIR}/upload.php ${D}/www/pages/upload.php

	install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/cgibashopts/cgibashopts ${D}${bindir}/

    install -m 0644 ${WORKDIR}/lighttpd-deadsimple-installer.conf ${D}${sysconfdir}/${PN}/${PN}.conf
}

FILES_${PN} += "${bindir}/cgibashopts ${sysconfdir}/${PN}.d/deadsimple-installer.conf"
