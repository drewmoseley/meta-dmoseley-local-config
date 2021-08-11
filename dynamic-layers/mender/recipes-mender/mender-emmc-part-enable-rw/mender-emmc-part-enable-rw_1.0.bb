FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
          file://emmc-part-enable-rw;subdir=${PN}-${PV} \
          file://emmc-part-disable-rw;subdir=${PN}-${PV} \
          file://LICENSE;subdir=${PN}-${PV} \
          "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit mender-state-scripts

do_compile() {
    #
    # Manage toggling rw on the emmc hardware partitions for successful installs and commits
    #
    cp emmc-part-enable-rw ${MENDER_STATE_SCRIPTS_DIR}/Download_Enter_10_emmc-part-enable-rw
    cp emmc-part-disable-rw ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_10_emmc-part-disble-rw
    cp emmc-part-enable-rw ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Enter_10_emmc-part-enable-rw
    cp emmc-part-disable-rw ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Leave_10_emmc-part-disable-rw

    #
    # Handle various error transitions
    #
    cp emmc-part-disable-rw ${MENDER_STATE_SCRIPTS_DIR}/Download_Error_10_emmc-part-disable-rw
    cp emmc-part-disable-rw ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Error_10_emmc-part-disable-rw
    cp emmc-part-disable-rw ${MENDER_STATE_SCRIPTS_DIR}/ArtifactCommit_Error_10_emmc-part-disable-rw
}
