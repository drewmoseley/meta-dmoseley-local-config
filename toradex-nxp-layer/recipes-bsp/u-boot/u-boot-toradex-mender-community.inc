FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Only add this patch if we don't have Mender. The meta-mender-community layer
# will provide it in that case.
SRC_URI_append_mx7 = " \
	${@bb.utils.contains("DISTRO_FEATURES", "mender-client-install", "", "file://0001-Set-default-display-resolution-to-800x480-WVGA.patch", d)} \
"
