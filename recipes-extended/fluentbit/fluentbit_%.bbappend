FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FLEET_SERVER_URI ?= "vhost.lab.moseleynet.net"

SRC_URI += " \
    file://input_cpu.conf \
    file://input_disk.conf \
    file://input_klogs.conf \
    file://input_mem.conf \
    file://input_net.conf \
    file://input_osinfo.conf \
    file://input_thermal.conf \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/*.conf ${D}${sysconfdir}/td-agent-bit
    sed -i -e 's/@FLEET_SERVER_URI@/${FLEET_SERVER_URI}/g' ${D}${sysconfdir}/td-agent-bit/*.conf
    echo '' >> ${D}${sysconfdir}/td-agent-bit/td-agent-bit.conf
    echo '@INCLUDE input_*.conf' >> ${D}${sysconfdir}/td-agent-bit/td-agent-bit.conf
}

SYSTEMD_AUTO_ENABLE = "enable"
