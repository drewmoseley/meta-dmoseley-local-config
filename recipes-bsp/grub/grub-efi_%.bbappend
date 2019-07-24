FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

GRUB_BUILDIN_append = " all_video gfxterm tga gfxterm_background"

SRC_URI += " \
    file://${GRUB_SPLASH_IMAGE_FILE} \
    file://unifont.pf2 \
"

do_deploy_append() {
    if [ "${PN}" = "${BPN}" ]; then
        # Only install these files from the target package, and not the native one
        install -m 644 ${WORKDIR}/${GRUB_SPLASH_IMAGE_FILE} ${DEPLOYDIR}
        install -m 644 ${WORKDIR}/unifont.pf2 ${DEPLOYDIR}
    fi
}

# Note, unifont.pf2 is a free font available at: http://unifoundry.com/pub/unifont/unifont-12.1.02/font-builds/
# The license is stored here under the name COPYING.fonts.
# This font was converted on an Ubuntu 18 build system using the following:
#    grub-mkfont -o unifont.pf2  ./unifont-12.1.02.bdf.gz
# Ideally we would build grub-mkfont during the bitbake build and use that but the
# dependencies made it difficult so I just manually did it.
