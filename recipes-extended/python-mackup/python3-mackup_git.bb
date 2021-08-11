SUMMARY = "Keep your application settings in sync"
DESCRIPTION = "Keep your application settings in sync"
HOMEPAGE = "https://github.com/lra/mackup"
LICENSE = "GPLv3+"

inherit setuptools3

S = "${WORKDIR}/git"

SRC_URI = " \
    git://github.com/lra/mackup.git;protocol=https;branch=master \
    file://0001-webstorm-Remove-duplicated-setting.patch \
"
SRCREV = "e71c12903d9ada84bceed1bed5a680a1e486c55d"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9965f885e44bff7f6acc3721e3ad090a"
RDEPENDS:${PN} += "git python3-docopt "

