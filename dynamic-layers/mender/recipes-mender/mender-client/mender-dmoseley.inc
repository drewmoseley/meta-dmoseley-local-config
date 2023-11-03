FILESEXTRAPATHS:prepend := "${THISDIR}/files:/work/dmoseley/local:"

require /work/dmoseley/local/mender-dmoseley-certs.inc

SRC_URI:append = " \
     file://artifact-verify-key.pem \
     file://mender-inventory-yocto-buildinfo \
"

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "30"

MENDER_SERVER_URL:dmoseley-mender-prod-server = "https://aruba.lab.moseleynet.net"
MENDER_SERVER_URL:dmoseley-mender-staging-server = "https://staging.hosted.mender.io"
MENDER_SERVER_URL:dmoseley-mender-hosted-server = "https://hosted.mender.io"
MENDER_SERVER_URL:dmoseley-mender-hosted-personal-account-server = "https://hosted.mender.io"
MENDER_SERVER_URL:dmoseley-mender-migrate-to-hosted = ""

MENDER_TENANT_TOKEN:dmoseley-mender-staging-server = "${DMOSELEY_MENDER_STAGING_TOKEN}"
MENDER_TENANT_TOKEN:dmoseley-mender-hosted-server = "${DMOSELEY_MENDER_TOKEN}"
MENDER_TENANT_TOKEN:dmoseley-mender-hosted-personal-account-server = "${DMOSELEY_MENDER_PERSONAL_TOKEN}"
MENDER_TENANT_TOKEN:dmoseley-mender-migrate-to-hosted = "${DMOSELEY_MENDER_TOKEN}"

SRC_URI:append:dmoseley-mender-prod-server = " file://mender-server-dmoseley-prod.crt "
MENDER_CERT_LOCATION:dmoseley-mender-prod-server = "${sysconfdir}/mender/server.crt"
SRC_URI:append:dmoseley-mender-migrate-to-hosted = " file://mender-server-dmoseley-prod.crt "
MENDER_CERT_LOCATION:dmoseley-mender-migrate-to-hosted = "${sysconfdir}/mender/server.crt"

do_compile:append () {
    cat > ${WORKDIR}/mender.conf <<-EOF
	{
	  "StateScriptTimeoutSeconds": 100
	EOF
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-mender-migrate-to-hosted','true','false',d)}; then
    cat >> ${WORKDIR}/mender.conf <<-EOF
	  , "Servers": [
	    {"ServerURL": "https://hosted.mender.io"},
	    {"ServerURL": "https://aruba.lab.moseleynet.net"}
	  ]
	EOF
    fi
    cat >> ${WORKDIR}/mender.conf <<-EOF
	}
	EOF
}

do_install:append () {
    # install my additional inventory tools
    install -d ${D}/${datadir}/mender/inventory
    install -t ${D}/${datadir}/mender/inventory -m 0755 \
            ${WORKDIR}/mender-inventory-*

    if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-prod-server', 'true', 'false', d)}; then
        install -m 0444 ${WORKDIR}/mender-server-dmoseley-prod.crt ${D}/${MENDER_CERT_LOCATION}
    fi
    if ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-migrate-to-hosted', 'true', 'false', d)}; then
        install -m 0444 ${WORKDIR}/mender-server-dmoseley-prod.crt ${D}/${MENDER_CERT_LOCATION}
    fi
}

PACKAGECONFIG:append = " modules "
