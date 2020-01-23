FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

GRUB_BUILDIN_append = " all_video gfxterm tga gfxterm_background"

SRC_URI += " \
    file://${GRUB_SPLASH_IMAGE_FILE} \
    file://unifont.pf2 \
"

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'user-key-store', '', d)}
addtask dmoseley_sign after do_compile before do_install
python do_dmoseley_sign_class-target() {
    if bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', True, False, d):
        uks_bl_sign("%s/unifont.pf2" % d.getVar('WORKDIR'), d)
        uks_bl_sign("%s/%s" % (d.getVar('WORKDIR'), d.getVar('GRUB_SPLASH_IMAGE_FILE')), d)
}
do_dmoseley_sign[prefuncs] += "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'check_deploy_keys', '', d)}"
do_dmoseley_sign[prefuncs] += "${@'check_boot_public_key' if d.getVar('GRUB_SIGN_VERIFY', True) == '1' else ''}"

python do_dmoseley_sign() {
}

do_deploy_append_class-target() {
    if [ "${PN}" = "${BPN}" ]; then
        # Only install these files from the target package, and not the native one
        install -m 644 ${WORKDIR}/${GRUB_SPLASH_IMAGE_FILE} ${DEPLOYDIR}
        install -m 644 ${WORKDIR}/unifont.pf2 ${DEPLOYDIR}
        if "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'true', 'false', d)}"; then
            install -m 644 ${WORKDIR}/${GRUB_SPLASH_IMAGE_FILE}${SB_FILE_EXT} ${DEPLOYDIR}
            install -m 644 ${WORKDIR}/unifont.pf2${SB_FILE_EXT} ${DEPLOYDIR}
        fi
    fi
}

# Note, unifont.pf2 is a free font available at: http://unifoundry.com/pub/unifont/unifont-12.1.02/font-builds/
# The license is stored here under the name COPYING.fonts.
# This font was converted on an Ubuntu 18 build system using the following:
#    grub-mkfont -o unifont.pf2  ./unifont-12.1.02.bdf.gz
# Ideally we would build grub-mkfont during the bitbake build and use that but the
# dependencies made it difficult so I just manually did it.
