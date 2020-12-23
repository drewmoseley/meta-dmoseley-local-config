FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "file://ArtifactRollback_Enter_00;subdir=${BPN}-${PV} \
           file://Download_Enter_00;subdir=${BPN}-${PV} \
           file://LICENSE;subdir=${BPN}-${PV} \
           file://ArtifactCommit_Enter_00;subdir=${BPN}-${PV} \
           file://Sync_Enter_00;subdir=${BPN}-${PV} \
           file://debug-state-script;subdir=${BPN}-${PV} \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit mender-state-scripts

do_compile() {
    cp ArtifactRollback_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp Download_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp ArtifactCommit_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp Sync_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/

    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/Download_Enter_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/Download_Leave_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Enter_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Enter_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Leave_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Enter_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactRollback_Leave_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactFailure_Enter_00_debug
    cp debug-state-script ${MENDER_STATE_SCRIPTS_DIR}/ArtifactFailure_Leave_00_debug
}

RDEPENDS_${PN}_append = " netcat "
