SUMMARY = "Keep your application settings in sync (macOS/Linux)"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9965f885e44bff7f6acc3721e3ad090a"

SRC_URI = "git://github.com/lra/mackup;protocol=https;branch=master"

PV = "0.8.40+git"
SRCREV = "db744def2ba8410abb56d237b0a489bb3e6b8ae3"

S = "${WORKDIR}/git"

inherit python_poetry_core

RDEPENDS:${PN} = "python3-docopt"
