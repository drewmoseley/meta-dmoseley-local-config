FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://ArtifactRollback_Enter_00;subdir=${BPN}-${PV} \
           file://Download_Enter_00;subdir=${BPN}-${PV} \
           file://Download_Leave_00;subdir=${BPN}-${PV} \
           file://LICENSE;subdir=${BPN}-${PV} \
           file://ArtifactInstall_Enter_00;subdir=${BPN}-${PV} \
           file://ArtifactCommit_Enter_00;subdir=${BPN}-${PV} \
           file://Sync_Enter_00;subdir=${BPN}-${PV} \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit mender-state-scripts

do_compile() {
    cp ArtifactRollback_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp Download_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp Download_Leave_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp ArtifactInstall_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp ArtifactCommit_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp Sync_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
}

RDEPENDS:${PN}:append = " netcat "
