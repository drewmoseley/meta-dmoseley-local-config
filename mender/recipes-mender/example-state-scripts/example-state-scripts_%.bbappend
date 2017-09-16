FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://Download_Enter_00;subdir=${PN}-${PV} \
    file://ArtifactCommit_Enter_00;subdir=${PN}-${PV} \
"
do_compile_append() {
    cp Download_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
    cp ArtifactCommit_Enter_00 ${MENDER_STATE_SCRIPTS_DIR}/
}
