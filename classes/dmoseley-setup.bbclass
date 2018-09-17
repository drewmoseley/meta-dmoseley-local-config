DMOSELEY_FEATURES ?= ""

python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-systemd',              # Use systemd
        'dmoseley-networkd',             # Use systemd-networkd
        'dmoseley-networkmanager',       # Use networkmanager
        'dmoseley-connman',              # Use connman
        'dmoseley-wifi',                 # Use wifi and install device firmware blobs
        'dmoseley-localntp',             # Use a custom local NTP server
        'dmoseley-mender-prod-server',   # Use an on-prem deployment of the Mender production server
        'dmoseley-mender-demo-server',   # Use the standard Mender demo server from the canned integration environment
        'dmoseley-mender-hosted-server', # Use hosted Mender
    }

    for feature in d.getVar('DMOSELEY_FEATURES', True).split():
        if feature.startswith("dmoseley-"):
            if feature not in dmoseley_local_features:
                bb.fatal("%s from DMOSELEY_FEATURES is not a valid local feature."
                         % feature)
            d.setVar('OVERRIDES_append', ':%s' % feature)

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building connman without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d):
        bb.fatal("Building connman and system-networkd together is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', True, False, d):
        bb.fatal("Building connman and networkmanager together is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', True, False, d):
        bb.fatal("Building system-networkd and networkmanager together is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-demo-server', True, False, d):
        if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-prod-server', True, False, d):
            bb.fatal("Cannot use dmoseley-mender-prod-server with dmoseley-mender-demo-server.")
        if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-hosted-server', True, False, d):
            bb.fatal("Cannot use dmoseley-mender-hosted-server with dmoseley-mender-demo-server.")
        if not bb.utils.contains('BBFILE_COLLECTIONS', 'mender-demo', True, False, d):
            bb.fatal("The mender-demo layer requires use of dmoseley-mender-demo-server.")
    elif bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-prod-server', True, False, d):
        if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-demo-server', True, False, d):
            bb.fatal("Cannot use dmoseley-mender-demo-server with dmoseley-mender-prod-server.")
        if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-hosted-server', True, False, d):
            bb.fatal("Cannot use dmoseley-mender-hosted-server with dmoseley-mender-prod-server.")
        if bb.utils.contains('BBFILE_COLLECTIONS', 'mender-demo', True, False, d):
            bb.fatal("The mender-demo layer must not be used with dmoseley-mender-prod-server.")
    elif bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-hosted-server', True, False, d):
        if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-demo-server', True, False, d):
            bb.fatal("Cannot use dmoseley-mender-demo-server with dmoseley-mender-hosted-server.")
        if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender-prod-server', True, False, d):
            bb.fatal("Cannot use dmoseley-mender-prod-server with dmoseley-mender-hosted-server.")
        if bb.utils.contains('BBFILE_COLLECTIONS', 'mender-demo', True, False, d):
            bb.fatal("The mender-demo layer must not be used with dmoseley-mender-hosted-server.")
    else:
        bb.fatal("Must specify exactly one of dmoseley-mender-prod-server, dmoseley-mender-demo-server, dmoseley-mender-hosted-server.")
}

IMAGE_INSTALL_append_dmoseley-connman += " connman connman-client"
IMAGE_INSTALL_append_dmoseley-networkmanager += " networkmanager networkmanager-nmtui"

DISTRO_FEATURES_append_dmoseley-wifi += " wifi"
IMAGE_INSTALL_append_dmoseley-wifi += " \
    iw wpa-supplicant \
    ${@bb.utils.contains('MACHINE', 'beaglebone', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'chip', 'linux-firmware-rtl8723 kernel-module-r8723bs rtl8723bs', '', d)} \
    ${@bb.utils.contains('MACHINE', 'overo', 'linux-firmware-wl12xx linux-firmware-wl18xx wl18xx-fw', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi-cm', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi0-wifi', 'linux-firmware-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi2', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi3', 'linux-firmware-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'udooneo', 'linux-firmware-wl18xx', '', d)} \
"

# Enable systemd if required
DISTRO_FEATURES_append = " ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', 'systemd', '', d)}"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', 'sysvinit', '', d)}"
VIRTUAL-RUNTIME_init_manager_dmoseley-systemd = "systemd"
VIRTUAL-RUNTIME_initscripts_dmoseley-systemd = ""

# Explicitly remove wifi from qemu buids
DISTRO_FEATURES_remove_vexpress-qemu += " wifi"
DISTRO_FEATURES_remove_vexpress-qemu-flash += " wifi"
IMAGE_INSTALL_remove_vexpress-qemu += " iw wpa-supplicant"
IMAGE_INSTALL_remove_vexpress-qemu-flash += " iw wpa-supplicant"

# Cleanup FSTYPES
IMAGE_FSTYPES_APPEND_MENDER = " \
"
IMAGE_FSTYPES_REMOVE_MENDER = " \
    ext4 ext3 \
    jffs2 jffs2.bz2 jffs2.gz jffs2.xz \
    rpi-sdimg rpi-sdimg.bz2 rpi-sdimg.gz rpi-sdimg.xz rpi-sdimg.bmap \
    sdcard sdcard.gz sdcard.bz2 sdcard.xz \
    tar tar.bz2 tar.gz tar.xz \
    teziimg.bz2 teziimg.gz teziimg.xz \
    wic wic.bz2 wic.gz wic.xz wic.bmap \
"
IMAGE_FSTYPES_APPEND_COMMUNITY = " \
    ext4 tar.xz \
    ${@bb.utils.contains("MACHINE", "beaglebone", "jffs2.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "colibri-imx7", "sdcard.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "colibri-vf", "sdcard.bmap", "", d)} \
    ${@bb.utils.contains("SOC_FAMILY", "rpi", "rpi-sdimg.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "udooneo", "wic.bmap", "", d)} \
"
IMAGE_FSTYPES_REMOVE_COMMUNITY = " \
    ext3 \
    tar tar.bz2 tar.gz \
    ${@bb.utils.contains("MACHINE", "chip", "ext4", "", d)} \
"

IMAGE_FSTYPES_append += " ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", " ${IMAGE_FSTYPES_APPEND_MENDER}", " ${IMAGE_FSTYPES_APPEND_COMMUNITY}", d)}"
IMAGE_FSTYPES_remove += " ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", " ${IMAGE_FSTYPES_REMOVE_MENDER}", " ${IMAGE_FSTYPES_REMOVE_COMMUNITY}", d)}"

DMOSELEY_LOCAL_NTP_ADDRESS ??= "192.168.1.36"

# Setup Mender disk sizes
MENDER_STORAGE_TOTAL_SIZE_MB_rpi ??= "1024"
MENDER_STORAGE_TOTAL_SIZE_MB_beaglebone ??= "1024"

# Multimedia licensing
LICENSE_FLAGS_WHITELIST_append_rpi += "commercial"
LICENSE_FLAGS_WHITELIST_append_colibri-imx7-mender += "commercial"

# RPI specifics
IMAGE_INSTALL_append_rpi += " userland bluez5-noinst-tools"
VIDEO_CAMERA_rpi = "1"
GPU_MEM_rpi = "128"
KERNEL_IMAGETYPE_rpi = "uImage"
# raspberrypi files aligned with mender layout requirements
IMAGE_BOOT_FILES_append_rpi += " boot.scr u-boot.bin;${SDIMG_KERNELIMAGE}"
IMAGE_INSTALL_append_rpi += " kernel-image kernel-devicetree"
ENABLE_UART_rpi = "1"
RPI_EXTRA_CONFIG = " \n\
 # Raspberry Pi 7 inch display/touch screen \n\
 lcd_rotate=2 \n\
"
SDIMG_ROOTFS_TYPE_rpi = "ext4"

# Other packages to install in _all_ images
IMAGE_INSTALL_append_genericx86 += " v86d"
IMAGE_INSTALL_append += " kernel-image kernel-modules kernel-devicetree"
IMAGE_INSTALL_remove_vexpress-qemu-flash += " kernel-image kernel-modules kernel-devicetree"
IMAGE_INSTALL_remove_x86 += " kernel-devicetree"
IMAGE_INSTALL_remove_x86-64 += " kernel-devicetree"
IMAGE_INSTALL_append += " libnss-mdns"
IMAGE_INSTALL_remove_vexpress-qemu += " libnss-mdns"
IMAGE_INSTALL_remove_vexpress-qemu-flash += " libnss-mdns"

# Remove wayland on Udooneo.  This allows X11 based builds to succeed
# See https://lists.yoctoproject.org/pipermail/meta-freescale/2016-November/019638.html
DISTRO_FEATURES_remove_udooneo = " wayland"

EXTRA_IMAGE_FEATURES_append += " ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", "", " package-management", d)}"

# Now install all of packagegroup-base which pulls in things from MACHINE_EXTRA_RDEPENDS and
# MACHINE_EXTRA_RRECOMMENDS.  This is not included by default in core-image-minimal and
# core-image-full-cmdline but it has some handy packages so let's include it by default.
# If certain builds are size constrained this (as well as package-management) should be
# removed.
IMAGE_INSTALL_append += "packagegroup-base"
IMAGE_INSTALL_remove_vexpress-qemu-flash += "packagegroup-base"

# Mender settings
MENDER_BOOT_PART_SIZE_MB_rpi ??= "40"
MENDER_PARTITION_ALIGNMENT_KB_rpi ??= "4096"
IMAGE_INSTALL_append += " ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", " drew-state-scripts", "", d)}"
MENDER_ARTIFACT_SIGNING_KEY = "/work/dmoseley/local/mender-artifact-signing-private.key"

add_dmoseley_data() {
   local buildhost=$(hostname)
   case $(hostname) in
        ip-172-30-0-144 ) buildhost="menderBuild";;
   esac
   cat > ${IMAGE_ROOTFS}${sysconfdir}/yocto-dmoseley-release <<-EOF
	yocto_image=${IMAGE_BASENAME}
	yocto_buildhost=$buildhost
	EOF
}

ROOTFS_POSTPROCESS_COMMAND += "add_dmoseley_data ; "
