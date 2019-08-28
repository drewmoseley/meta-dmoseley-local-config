DESCRIPTION = "Test for golang allocation bug"
HOMEPAGE = "https://mender.io"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM="file://${WORKDIR}/LICENSE;md5=c9706ee45e2e5250f0086455b15ef297"

inherit go

FILES_${PN} += "${bindir}/gofork"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = " \
    file://gofork.go \
    file://LICENSE \
"

S="${WORKDIR}/src"

GO_IMPORT = "github.com/drew"

do_patch() {
   install -d ${S}/src/github.com/drew/
   install -m 644 ${WORKDIR}/gofork.go ${S}/src/github.com/drew
}
