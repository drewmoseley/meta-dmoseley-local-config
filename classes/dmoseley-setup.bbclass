DMOSELEY_FEATURES = "dmoseley-setup dmoseley-systemd dmoseley-wifi"
OVERRIDES =. "dmoseley-setup:"

python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-setup',                # Basic setup -- flag for conditional settings
        'dmoseley-mender',               # Use mender
        'dmoseley-systemd',              # Use systemd
        'dmoseley-networkd',             # Use systemd-networkd
        'dmoseley-networkmanager',       # Use networkmanager
        'dmoseley-connman',              # Use connman
        'dmoseley-wifi-connect',         # Use wifi-connect
        'dmoseley-wifi',                 # Use wifi and install device firmware blobs
        'dmoseley-localntp',             # Use a custom local NTP server
        'dmoseley-mender-prod-server',   # Use an on-prem deployment of the Mender production server
        'dmoseley-mender-demo-server',   # Use the standard Mender demo server from the canned integration environment
        'dmoseley-mender-hosted-server', # Use hosted Mender
        'dmoseley-mender-staging-server', # Use staging hosted Mender
        'dmoseley-mender-migrate-to-hosted',  # Migrate from production to hosted
        'dmoseley-access-point',         # Enable access point mode
        'dmoseley-fastboot',             # Fastboot mode
        'dmoseley-journal-upload',       # Enable systemd journal upload
        'dmoseley-readonly',             # Use readonly
    }

    for feature in d.getVar('DMOSELEY_FEATURES').split():
        if feature.startswith("dmoseley-"):
            if feature not in dmoseley_local_features:
                bb.fatal("%s from DMOSELEY_FEATURES is not a valid local feature."
                         % feature)
            d.setVar('OVERRIDES_append', ':%s' % feature)

    numberOfNetworkManagersConfigured=0
    for networkManager in [ "networkd", "networkmanager", "connman", "wifi-connect" ]:
        if bb.utils.contains('DMOSELEY_FEATURES', "dmoseley-" + networkManager, True, False, d):
            numberOfNetworkManagersConfigured += 1
    if (numberOfNetworkManagersConfigured != 1):
        bb.fatal("Must specify exactly one network manager.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building networkd without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building connman without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', False, True, d):
        bb.fatal("Building access-point requires networkmanager.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender', True, False, d):
        numberOfServersConfigured=0
        for serverType in [ "demo-server", "prod-server", "hosted-server", "staging-server", "migrate-to-hosted" ]:
            if bb.utils.contains('DMOSELEY_FEATURES', "dmoseley-mender-" + serverType, True, False, d):
                numberOfServersConfigured += 1
        if (numberOfServersConfigured != 1):
            bb.fatal("Must specify exactly one server type.")
}

DMOSELEY_MENDER_BBCLASS_colibri-imx7-nand = "mender-full-ubi"
DMOSELEY_MENDER_BBCLASS_vexpress-qemu-flash = "mender-full-ubi"
DMOSELEY_MENDER_BBCLASS_qemux86-64-bios = "mender-full-bios"
DMOSELEY_MENDER_BBCLASS = "mender-full"
inherit ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender', '${DMOSELEY_MENDER_BBCLASS}', '', d)}

IMAGE_INSTALL_append_dmoseley-connman = " connman connman-client "
IMAGE_INSTALL_append_dmoseley-networkmanager = " networkmanager networkmanager-nmtui "
IMAGE_INSTALL_append_dmoseley-wifi-connect = " wifi-connect "

DISTRO_FEATURES_append_dmoseley-wifi = " wifi "
IMAGE_INSTALL_append_dmoseley-wifi = " \
    iw wpa-supplicant \
    ${@bb.utils.contains('MACHINE', 'beaglebone-yocto', 'linux-firmware-wl18xx kernel-module-wl18xx linux-firmware-ralink linux-firmware-rtl8188 linux-firmware-rtl8192ce linux-firmware-rtl8192cu linux-firmware-rtl8192su', '', d)} \
    ${@bb.utils.contains('MACHINE', 'colibri-imx7-nand', 'linux-firmware-ralink linux-firmware-rtl8188', '', d)} \
    ${@bb.utils.contains('MACHINE', 'overo', 'linux-firmware-wl12xx linux-firmware-wl18xx wl18xx-fw', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi-cm', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi0-wifi', 'linux-firmware-rpidistro-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi2', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi3', 'linux-firmware-rpidistro-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'udooneo', 'linux-firmware-wl18xx', '', d)} \
    ${@bb.utils.contains('MACHINE', 'imx7dsabresd', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'up-squared', 'linux-firmware-rtl8188 kernel-module-r8188eu', '', d)} \
"

KERNEL_DEVICETREE_append_beaglebone-yocto = " am335x-boneblack-wireless.dtb "
IMAGE_BOOT_FILES_append_beaglebone-yocto = " am335x-boneblack-wireless.dtb "

# Enable systemd if required
DISTRO_FEATURES_append = " ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', 'systemd', '', d)} "
DISTRO_FEATURES_BACKFILL_CONSIDERED = "${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', 'sysvinit', '', d)}"
VIRTUAL-RUNTIME_init_manager_dmoseley-systemd = "systemd"
VIRTUAL-RUNTIME_initscripts_dmoseley-systemd = ""

# Explicitly remove wifi from qemu buids
DISTRO_FEATURES_remove_vexpress-qemu = "wifi"
DISTRO_FEATURES_remove_vexpress-qemu-flash = "wifi"
IMAGE_INSTALL_remove_vexpress-qemu = "iw wpa-supplicant"
IMAGE_INSTALL_remove_vexpress-qemu-flash = "iw wpa-supplicant"

# Cleanup FSTYPES
IMAGE_FSTYPES_APPEND_MENDER = " \
"
IMAGE_FSTYPES_REMOVE_MENDER = " \
    ext4 ext3 \
    jffs2 jffs2.bz2 jffs2.gz jffs2.xz \
    sdcard sdcard.gz sdcard.bz2 sdcard.xz \
    tar tar.bz2 tar.gz tar.xz \
    wic wic.bz2 wic.gz wic.xz wic.bmap \
    teziimg sdimg.bz2 uefiimg.bz2 mender.bmap \
"
IMAGE_FSTYPES_APPEND_COMMUNITY = " \
    ext4 tar.xz \
    ${@bb.utils.contains("MACHINE", "beaglebone-yocto", "jffs2.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "colibri-vf", "wic.bmap", "", d)} \
    ${@bb.utils.contains("SOC_FAMILY", "rpi", "wic", "", d)} \
    ${@bb.utils.contains("MACHINE", "udooneo", "wic.bmap", "", d)} \
"
IMAGE_FSTYPES_REMOVE_COMMUNITY = " \
    ext3 \
    tar tar.bz2 tar.gz \
    ${@bb.utils.contains("MACHINE", "chip", "ext4", "", d)} \
    ${@bb.utils.contains("SOC_FAMILY", "rpi", "wic.bz2", "", d)} \
"

IMAGE_FSTYPES_append = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", " ${IMAGE_FSTYPES_APPEND_MENDER}", " ${IMAGE_FSTYPES_APPEND_COMMUNITY}", d)} "
IMAGE_FSTYPES_remove = "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", " ${IMAGE_FSTYPES_REMOVE_MENDER}", " ${IMAGE_FSTYPES_REMOVE_COMMUNITY}", d)}"

DMOSELEY_LOCAL_NTP_ADDRESS ??= "192.168.7.41"

# Setup Mender disk sizes
MENDER_BOOT_PART_SIZE_MB_rpi ??= "40"
MENDER_STORAGE_TOTAL_SIZE_MB_rpi ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB_beaglebone-yocto ??= "1024"
MENDER_STORAGE_TOTAL_SIZE_MB_genericx86-64 ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB_genericx86 ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB_intel-corei7-64 ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB_up-squared ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB_minnowboard ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB_colibri-imx7-nand = "512"
MENDER_STORAGE_TOTAL_SIZE_MB_variscite = "2048"
MENDER_MTDIDS_colibri-imx7-nand = "nand0=gpmi-nand"
MENDER_MTDPARTS_colibri-imx7-nand = "gpmi-nand:512k(mx7-bcb),1536k(u-boot1)ro,1536k(u-boot2)ro,512k(u-boot-env),-(ubi)"
MENDER_STORAGE_PEB_SIZE_colibri-imx7-nand = "131072"

# Multimedia licensing
LICENSE_FLAGS_WHITELIST_append = " commercial "

# RPI specifics
IMAGE_INSTALL_append_rpi = " bluez5-noinst-tools "
RPI_USE_U_BOOT_rpi = "1"
ENABLE_UART_rpi = "1"
DISABLE_OVERSCAN_rpi = "1"
DISABLE_SPLASH = "1"
BOOT_DELAY_rpi = "0"
BOOT_DELAY_MS_rpi = "0"
DISABLE_RPI_BOOT_LOGO_dmoseley-fastboot = "1"
RPI_EXTRA_CONFIG_append = " \nlcd_rotate=2\n "
SDIMG_ROOTFS_TYPE_rpi = "ext4"

# This is needed for the Pi Foundation Display to work with VC4.
VC4DTBO_rpi = "vc4-fkms-v3d"

# Other packages to install in _all_ images
IMAGE_INSTALL_append = " kernel-image kernel-modules kernel-devicetree "
IMAGE_INSTALL_remove_vexpress-qemu-flash = "kernel-image kernel-modules kernel-devicetree"
IMAGE_INSTALL_remove_qemuarm = "kernel-devicetree"
IMAGE_INSTALL_remove_intel-corei7-64 = "kernel-devicetree"
IMAGE_INSTALL_remove_up-squared = "kernel-devicetree"
IMAGE_INSTALL_remove_minnowboard = "kernel-devicetree"
IMAGE_INSTALL_remove_qemux86 = "kernel-devicetree"
IMAGE_INSTALL_remove_qemux86-64 = "kernel-devicetree"
IMAGE_INSTALL_remove_genericx86 = "kernel-devicetree"
IMAGE_INSTALL_remove_genericx86-64 = "kernel-devicetree"
IMAGE_INSTALL_append = " libnss-mdns "
IMAGE_INSTALL_remove_vexpress-qemu = "libnss-mdns"
IMAGE_INSTALL_remove_vexpress-qemu-flash = "libnss-mdns"
IMAGE_INSTALL_append = " nano "

EXTRA_IMAGE_FEATURES_append = " package-management "
PACKAGE_FEED_URIS = "http://aruba.lab.moseleynet.net:5678"

# Now install all of packagegroup-base which pulls in things from MACHINE_EXTRA_RDEPENDS and
# MACHINE_EXTRA_RRECOMMENDS.  This is not included by default in core-image-minimal and
# core-image-full-cmdline but it has some handy packages so let's include it by default.
# If certain builds are size constrained this (as well as package-management) should be
# removed.
IMAGE_INSTALL_append = " packagegroup-base "
IMAGE_INSTALL_remove_vexpress-qemu-flash = "packagegroup-base"

# Mender settings
IMAGE_INSTALL_append = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", " drew-state-scripts mender-ipk", "", d)} "

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

# Up Squared Board extra settings
SERIAL_CONSOLE_append_up-squared = " ttyS1 "
SERIAL_CONSOLES_append_up-squared = " 115200;ttyS1 "
MENDER_STORAGE_DEVICE_up-squared = "/dev/sda"

# intel-corei7-64 Board extra settings
SERIAL_CONSOLE_append_intel-corei7-64 = " ttyUSB0 "
SERIAL_CONSOLES_append_intel-corei7-64 = " 115200;ttyUSB0 "
KERNEL_CONSOLE_intel-corei7-64 = "ttyUSB0"

# Graphical display demo
IMAGE_INSTALL_append = " image-display "

# Disable console on VT/FB
USE_VT_dmoseley-fastboot = "0"

IMAGE_FEATURES += "hwcodecs"

# Full versions of various utilities
IMAGE_INSTALL_append = " \
    bind-utils \
    coreutils \
    findutils \
    iputils-ping \
    iputils-tracepath \
    ${@bb.utils.contains("DISTRO_FEATURES", "ipv6", "iputils-traceroute6", "", d)} \
    iproute2 \
    less \
    ncurses-terminfo \
    net-tools \
    procps \
    util-linux \
"

# Check for CVEs
# inherit cve-check

GRUB_SPLASH_IMAGE_FILE ?= "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "Mender.tga", "Max.tga", d)}"

# I'm not sure why this cannot be calculated using bitbake variable inline python syntax
# but when I do it that way, and SB is not enabled then the expansion is not done and the
# shell eventually chokes on the unknown syntax."
python () {
    splashfile = d.getVar("GRUB_SPLASH_IMAGE_FILE")
    extension = d.getVar("SB_FILE_EXT")
    if extension is not None and extension != "":
        d.setVar("EFI_SECUREBOOT_BOOT_FILES", "%s%s unifont.pf2%s:EFI/BOOT/fonts/unifont.pf2%s" % (splashfile, extension, extension, extension))
    else:
        d.setVar("EFI_SECUREBOOT_BOOT_FILES", "")
}
IMAGE_BOOT_FILES_append_intel-corei7-64 = " \
    ${GRUB_SPLASH_IMAGE_FILE} \
    unifont.pf2;EFI/BOOT/fonts/unifont.pf2 \
    ${EFI_SECUREBOOT_BOOT_FILES} \
"

MENDER_FEATURES_ENABLE_append_dmoseley-mender = " mender-persist-systemd-machine-id "
MENDER_FEATURES_DISABLE_append_dmoseley-mender = " mender-growfs-data "

#
# Settings for Toradex boards
#
OVERRIDES_prepend = "${@'toradex:' if d.getVar('MACHINE',True).startswith('colibri') or d.getVar('MACHINE',True).startswith('apalis') else ''}"
MACHINE_BOOT_FILES_remove_mender-grub_toradex = "boot.scr"
PREFERRED_PROVIDER_u-boot_toradex = "u-boot-toradex"
PREFERRED_PROVIDER_virtual/bootloader_toradex = "u-boot-toradex"
PREFERRED_PROVIDER_virtual/dtb_toradex = "device-tree-overlays"
IMAGE_TYPE_MENDER_TEZI=""
IMAGE_TYPE_MENDER_TEZI_toradex = "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "image_type_mender_tezi", "", d)}"
IMAGE_CLASSES_append = " ${IMAGE_TYPE_MENDER_TEZI} "
IMAGE_FSTYPES_append_toradex = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender_tezi", "", d)}"
TORADEX_INCLUDE_FILE=""
TORADEX_INCLUDE_FILE_toradex="conf/machine/include/${MACHINE}.inc"
TORADEX_INCLUDE_FILE_colibri-vf=""
require ${TORADEX_INCLUDE_FILE}
MENDER_STORAGE_DEVICE_apalis-imx6 = "/dev/mmcblk2"
MENDER_UBOOT_STORAGE_DEVICE_apalis-imx6 = "0"
MENDER_STORAGE_DEVICE_colibri-imx7-emmc = "/dev/mmcblk0"
MENDER_UBOOT_STORAGE_DEVICE_colibri-imx7-emmc = "0"
MENDER_MTDIDS_colibri-imx7-nand = "nand0=gpmi-nand"
MENDER_MTDPARTS_colibri-imx7-nand = "gpmi-nand:512k(mx7-bcb),1536k(u-boot1)ro,1536k(u-boot2)ro,512k(u-boot-env),-(ubi)"
MENDER_IMAGE_BOOTLOADER_FILE_colibri-imx7-nand = "u-boot-nand.imx"
MENDER_PARTITION_ALIGNMENT_colibri-imx7-nand = "131072"
KERNEL_DEVICETREE_colibri-imx7-nand = "imx7d-colibri-aster.dtb"

#
# Settings for Variscite boards
#
OVERRIDES_prepend = "${@'variscite:' if 'var-' in d.getVar('MACHINE',True) else ''}"
MENDER_IMAGE_BOOTLOADER_FILE_imx6ul-var-dart = "u-boot-spl.img"
MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET_imx6ul-var-dart = "2"
MENDER_BOOT_PART_SIZE_MB_imx6ul-var-dart = "16"
IMAGE_BOOT_FILES_remove_imx6ul-var-dart_dmoseley-mender = "${KERNEL_IMAGETYPE} ${KERNEL_DEVICETREE}"
MENDER_IMAGE_BOOTLOADER_FILE_imx8mm-var-dart = "imx-boot"
MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET_imx8mm-var-dart = "66"
MENDER_BOOT_PART_SIZE_MB_imx8mm-var-dart = "16"
IMAGE_BOOT_FILES_remove_imx8mm-var-dart_dmoseley-mender = "${KERNEL_IMAGETYPE} ${@make_dtb_boot_files(d)}"
do_image_sdimg[depends] += "${@bb.utils.contains('MACHINE', 'imx8mm-var-dart', 'imx-boot:do_deploy', '', d)}"
MENDER_IMAGE_BOOTLOADER_FILE_imx8mn-var-som = "imx-boot"
MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET_imx8mn-var-som = "64"
MENDER_BOOT_PART_SIZE_MB_imx8mn-var-som = "16"
IMAGE_BOOT_FILES_remove_imx8mn-var-som_dmoseley-mender = "${KERNEL_IMAGETYPE} ${@make_dtb_boot_files(d)}"
do_image_sdimg[depends] += "${@bb.utils.contains('MACHINE', 'imx8mn-var-som', 'imx-boot:do_deploy', '', d)}"
MENDER_FEATURES_ENABLE_append_variscite = " mender-image-sd "
MENDER_FEATURES_DISABLE_append_variscite = " mender-image-uefi "
MACHINE_EXTRA_RDEPENDS_remove_variscite_dmoseley-mender = "u-boot-fw-utils"
VARISCITE_UBOOT_ENV_IN_EMMC = "1"
MENDER_STORAGE_DEVICE_imx6ul-var-dart = "/dev/mmcblk1"
MENDER_UBOOT_STORAGE_DEVICE_imx6ul-var-dart = "1"
UBOOT_CONFIG_imx6ul-var-dart = "sd"
MENDER_STORAGE_DEVICE_imx8mm-var-dart = "/dev/mmcblk2"
MENDER_UBOOT_STORAGE_DEVICE_imx8mm-var-dart = "1"
UBOOT_CONFIG_imx8mm-var-dart = "sd"
MENDER_STORAGE_DEVICE_imx8mn-var-som = "/dev/mmcblk2"
MENDER_UBOOT_STORAGE_DEVICE_imx8mn-var-som = "1"
UBOOT_CONFIG_imx8mm-var-dart = "sd"
PREFERRED_VERSION_linux-variscite_imx8mm-var-dart = "5.4.3"
PREFERRED_VERSION_imx-boot_imx8mm-var-dart = "0.2"
PREFERRED_VERSION_linux-variscite_imx6ul-var-dart = "5.4.3"
PREFERRED_PROVIDER_u-boot_mender-grub_variscite = "u-boot-variscite"
PREFERRED_PROVIDER_virtual/bootloader_mender-grub_variscite = "u-boot-variscite"

#
# Settings for NXP IMX EVK boards
#
PREFERRED_PROVIDER_u-boot_mender-grub_imx8mnddr4evk = "u-boot-imx"
PREFERRED_PROVIDER_virtual/bootloader_mender-grub_imx8mnddr4evk = "u-boot-imx"
IMAGE_CLASSES_append_imx8mnddr4evk_dmoseley-mender = " mender-setup-imx "
MENDER_BOOT_PART_SIZE_MB_imx8mnddr4evk = "256"
MENDER_STORAGE_TOTAL_SIZE_MB_imx8mnddr4evk = "2048"
MENDER_STORAGE_DEVICE_imx8mnddr4evk = "/dev/mmcblk2"

# This naming of the mender recipes is for zeus and newer
BBMASK += "/meta-dmoseley-private/mender/recipes-mender/mender/mender_%.bbappend"

# Default for HDMI
DMOSELEY_DISPLAY_RESOLUTION ?= "1920x1080"
DMOSELEY_DISPLAY_RESOLUTION_colibri-imx7-nand ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION_colibri-imx7-emmc ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION_rpi ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION_intel-corei7-64 ?= "800x600"

# Mender Commercial settings
IMAGE_INSTALL_append_arm = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender-binary-delta", "", d)}"
IMAGE_INSTALL_append_aarch64 = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender-binary-delta", "", d)}"
IMAGE_INSTALL_append_x86-64 = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender-binary-delta", "", d)}"
LICENSE_FLAGS_WHITELIST_append = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "commercial_mender-binary-delta", "", d)}"
FILESEXTRAPATHS_prepend_pn-mender-binary-delta := "/work2/dmoseley/mender-binary-delta-1.1.0/:"

ACCEPT_FSL_EULA = "1"

# Readonly settings
EXTRA_IMAGE_FEATURES_append_dmoseley-readonly = " read-only-rootfs "

##### TODO
#####
##### BUILD_REPRODUCIBLE_BINARIES = "1"
##### export PYTHONHASHSEED = "0"
##### export PERL_HASH_SEED = "0"
##### export TZ = 'UTC'
##### export SOURCE_DATE_EPOCH ??= "1520598896"
##### REPRODUCIBLE_TIMESTAMP_ROOTFS ??= "1520598896"
##### 
##### TOOLCHAIN = "clang"
##### musl
##### INHERIT += "buildhistory"
##### BUILDHISTORY_COMMIT = "1"
