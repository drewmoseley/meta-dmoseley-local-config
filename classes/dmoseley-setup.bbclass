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
        'dmoseley-mender-migrate-to-hosted',  # Migrate from production to hosted
        'dmoseley-access-point',         # Enable access point mode
        'dmoseley-fastboot',            # Fastboot mode
    }

    for feature in d.getVar('DMOSELEY_FEATURES').split():
        if feature.startswith("dmoseley-"):
            if feature not in dmoseley_local_features:
                bb.fatal("%s from DMOSELEY_FEATURES is not a valid local feature."
                         % feature)
            d.setVar('OVERRIDES_append', ':%s' % feature)

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building networkd without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building connman without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d):
        bb.fatal("Building connman and system-networkd together is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', True, False, d):
        bb.fatal("Building connman [and networkmanager together is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', True, False, d):
        bb.fatal("Building system-networkd and networkmanager together is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', False, True, d):
        bb.fatal("Building access-point requires networkmanager.")

    if bb.utils.contains('DISTRO_FEATURES', 'mender-install', True, False, d):
        numberOfServersConfigured=0
        for serverType in [ "demo-server", "prod-server", "hosted-server", "migrate-to-hosted" ]:
            if bb.utils.contains('DMOSELEY_FEATURES', "dmoseley-mender-" + serverType, True, False, d):
                numberOfServersConfigured += 1
        if (numberOfServersConfigured != 1):
            bb.fatal("Must specify exactly one server type.")
}

IMAGE_INSTALL_append_dmoseley-connman = " connman connman-client "
IMAGE_INSTALL_append_dmoseley-networkmanager = " networkmanager networkmanager-nmtui "

DISTRO_FEATURES_append_dmoseley-wifi = " wifi "
IMAGE_INSTALL_append_dmoseley-wifi = " \
    iw wpa-supplicant \
    ${@bb.utils.contains('MACHINE', 'beaglebone', 'linux-firmware-wl18xx kernel-module-wl18xx linux-firmware-ralink linux-firmware-rtl8188 linux-firmware-rtl8192ce linux-firmware-rtl8192cu linux-firmware-rtl8192su', '', d)} \
    ${@bb.utils.contains('MACHINE', 'colibri-imx7', 'kernel-module-rt2500usb kernel-module-rtl8192cu kernel-module-r8188eu linux-firmware-ralink linux-firmware-rtl8192cu linux-firmware-rtl8188 linux-firmware-rtl8188eu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'colibri-imx7-mender', 'kernel-module-rt2500usb kernel-module-rtl8192cu kernel-module-r8188eu linux-firmware-ralink linux-firmware-rtl8192cu linux-firmware-rtl8188 linux-firmware-rtl8188eu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'chip', 'linux-firmware-rtl8723 kernel-module-r8723bs rtl8723bs', '', d)} \
    ${@bb.utils.contains('MACHINE', 'overo', 'linux-firmware-wl12xx linux-firmware-wl18xx wl18xx-fw', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi-cm', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi0-wifi', 'linux-firmware-raspbian-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi2', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi3', 'linux-firmware-raspbian-bcm43430', '', d)} \
    ${@bb.utils.contains('MACHINE', 'udooneo', 'linux-firmware-wl18xx', '', d)} \
    ${@bb.utils.contains('MACHINE', 'imx7dsabresd', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'up-board', 'linux-firmware-rtl8188 kernel-module-r8188eu', '', d)} \
"

KERNEL_DEVICETREE_append_beaglebone = " am335x-boneblack-wireless.dtb "
IMAGE_BOOT_FILES_append_beaglebone = " am335x-boneblack-wireless.dtb "

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
    rpi-sdimg rpi-sdimg.bz2 rpi-sdimg.gz rpi-sdimg.xz rpi-sdimg.bmap \
    sdcard sdcard.gz sdcard.bz2 sdcard.xz \
    tar tar.bz2 tar.gz tar.xz \
    wic wic.bz2 wic.gz wic.xz wic.bmap \
"
IMAGE_FSTYPES_APPEND_COMMUNITY = " \
    ext4 tar.xz \
    ${@bb.utils.contains("MACHINE", "beaglebone", "jffs2.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "colibri-vf", "wic.bmap", "", d)} \
    ${@bb.utils.contains("SOC_FAMILY", "rpi", "rpi-sdimg.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "udooneo", "wic.bmap", "", d)} \
    ${@bb.utils.contains("MACHINE", "pico-imx6ul", "sdcard.gz", "", d)} \
    ${@bb.utils.contains("MACHINE", "pico-imx7", "sdcard.gz", "", d)} \
"
IMAGE_FSTYPES_REMOVE_COMMUNITY = " \
    ext3 \
    tar tar.bz2 tar.gz \
    ${@bb.utils.contains("MACHINE", "chip", "ext4", "", d)} \
    ${@bb.utils.contains("MACHINE", "pico-imx6ul", "wic.gz", "", d)} \
    ${@bb.utils.contains("MACHINE", "pico-imx7", "wic.gz", "", d)} \
"

IMAGE_FSTYPES_append = " ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", " ${IMAGE_FSTYPES_APPEND_MENDER}", " ${IMAGE_FSTYPES_APPEND_COMMUNITY}", d)} "
IMAGE_FSTYPES_remove = "${@bb.utils.contains("DISTRO_FEATURES", "mender-install", " ${IMAGE_FSTYPES_REMOVE_MENDER}", " ${IMAGE_FSTYPES_REMOVE_COMMUNITY}", d)}"

DMOSELEY_LOCAL_NTP_ADDRESS ??= "192.168.7.41"

# Setup Mender disk sizes
MENDER_STORAGE_TOTAL_SIZE_MB_rpi ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB_beaglebone ??= "1024"
MENDER_STORAGE_TOTAL_SIZE_MB_genericx86-64 ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB_genericx86 ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB_up-board = "4096"
MENDER_STORAGE_TOTAL_SIZE_MB_intel-corei7-64 = "4096"
MENDER_STORAGE_TOTAL_SIZE_MB_pico-imx7 ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB_pico-imx6ul ??= "2048"

# Multimedia licensing
LICENSE_FLAGS_WHITELIST_append_rpi = " commercial "
LICENSE_FLAGS_WHITELIST_append_colibri-imx7-mender = " commercial "
LICENSE_FLAGS_WHITELIST_append_colibri-imx7 = " commercial "

# RPI specifics
IMAGE_INSTALL_append_rpi = " bluez5-noinst-tools "
VIDEO_CAMERA_rpi = "1"
GPU_MEM_rpi = "128"
RPI_USE_U_BOOT_rpi = "1"
ENABLE_UART_rpi = "1"
RPI_EXTRA_CONFIG = "lcd_rotate=2"
SDIMG_ROOTFS_TYPE_rpi = "ext4"

# Other packages to install in _all_ images
IMAGE_INSTALL_append_genericx86 = " v86d "
IMAGE_INSTALL_append = " kernel-image kernel-modules kernel-devicetree "
IMAGE_INSTALL_remove_vexpress-qemu-flash = "kernel-image kernel-modules kernel-devicetree"
IMAGE_INSTALL_remove_x86 = "kernel-devicetree"
IMAGE_INSTALL_remove_x86-64 = "kernel-devicetree"
IMAGE_INSTALL_append = " libnss-mdns "
IMAGE_INSTALL_remove_vexpress-qemu = "libnss-mdns"
IMAGE_INSTALL_remove_vexpress-qemu-flash = "libnss-mdns"

EXTRA_IMAGE_FEATURES_append = " package-management "
PACKAGE_FEED_URIS = "http://tobago.home.moseleynet.net:5678"

# Now install all of packagegroup-base which pulls in things from MACHINE_EXTRA_RDEPENDS and
# MACHINE_EXTRA_RRECOMMENDS.  This is not included by default in core-image-minimal and
# core-image-full-cmdline but it has some handy packages so let's include it by default.
# If certain builds are size constrained this (as well as package-management) should be
# removed.
IMAGE_INSTALL_append = " packagegroup-base "
IMAGE_INSTALL_remove_vexpress-qemu-flash = "packagegroup-base"
IMAGE_INSTALL_remove_colibri-imx7-mender = "packagegroup-base"

# Mender settings
MENDER_BOOT_PART_SIZE_MB_rpi ??= "40"
MENDER_PARTITION_ALIGNMENT_KB_rpi ??= "4096"
IMAGE_INSTALL_append = " ${@bb.utils.contains("DISTRO_FEATURES", "mender-install", " drew-state-scripts mender-ipk", "", d)} "

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
SERIAL_CONSOLE_append_up-board = " ttyS1 "
SERIAL_CONSOLES_append_up-board = " 115200;ttyS1 "
MENDER_STORAGE_DEVICE_up-board = "/dev/sda"
MENDER_GRUB_STORAGE_DEVICE_up-board = "hd0"

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
    iputils-traceroute6 \
    iproute2 \
    less \
    ncurses-terminfo \
    net-tools \
    procps \
    util-linux \
"

# Use Mender v2.x
PREFERRED_VERSION_pn-mender = "2.%"
PREFERRED_VERSION_pn-mender-artifact = "3.%"
PREFERRED_VERSION_pn-mender-artifact-native = "3.%"

# Settings for Technexion boards.
# These are normally set by the edm-setup-release.sh script
MACHINEOVERRIDES_append_pico-imx7 = ":brcm"
MACHINEOVERRIDES_append_pico-imx6ul = ":qca"
PREFERRED_PROVIDER_u-boot-fw-utils_pico-imx7 = "u-boot-edm-fw-utils"
PREFERRED_PROVIDER_u-boot-fw-utils_pico-imx6ul = "u-boot-edm-fw-utils"
PREFERRED_RPROVIDER_u-boot-fw-utils_pico-imx7 = "u-boot-edm-fw-utils"
PREFERRED_RPROVIDER_u-boot-fw-utils_pico-imx6ul = "u-boot-edm-fw-utils"
MENDER_STORAGE_DEVICE_pico-imx7 = "/dev/mmcblk2"
MENDER_UBOOT_STORAGE_INTERFACE_pico-imx7 = "mmc"
MENDER_UBOOT_STORAGE_DEVICE_pico-imx7 = "0"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1_pico-imx7 = "0xC0000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2_pico-imx7 = "0xE0000"
MENDER_STORAGE_DEVICE_pico-imx6ul = "/dev/mmcblk0"
MENDER_UBOOT_STORAGE_INTERFACE_pico-imx6ul = "mmc"
MENDER_UBOOT_STORAGE_DEVICE_pico-imx6ul = "0"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1_pico-imx6ul = "0xC0000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2_pico-imx6ul = "0xE0000"
IMAGE_BOOT_FILES_pico-imx7="u-boot.img uEnv.txt"
IMAGE_BOOTLOADER_FILE_pico-imx7="SPL"
MENDER_UBOOT_PRE_SETUP_COMMANDS_pico-imx7="run loadbootenv; run importbootenv; setenv kernel_addr_r \${loadaddr}; setenv bootargs console=\${console},\${baudrate}; run setfdt; setenv mender_dtb_name \${fdtfile}; "
IMAGE_BOOT_FILES_pico-imx6ul="u-boot.img uEnv.txt"
IMAGE_BOOTLOADER_FILE_pico-imx6ul="SPL"
MENDER_UBOOT_PRE_SETUP_COMMANDS_pico-imx6ul="run loadbootenv; run importbootenv; setenv kernel_addr_r \${loadaddr}; setenv bootargs console=\${console},\${baudrate}; run setfdt; setenv mender_dtb_name \${fdtfile}; "

#
# Settings for Variscite boards
#
PREFERRED_PROVIDER_u-boot-fw-utils_var-som-mx6 = "u-boot-fw-utils"
PREFERRED_RPROVIDER_u-boot-fw-utils_var-som-mx6 = "u-boot-fw-utils"
UBOOT_CONFIG_var-som-mx6 = "sd"
MENDER_UBOOT_STORAGE_DEVICE_var-som-mx6 = "0"
IMAGE_BOOTLOADER_FILE_var-som-mx6 = "u-boot-spl.img"
IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET_var-som-mx6 = "2"
MENDER_PARTITION_ALIGNMENT_KB_var-som-mx6 = "4096"
MENDER_STORAGE_DEVICE_var-som-mx6 = "/dev/mmcblk1"
MENDER_BOOT_PART_SIZE_MB_var-som-mx6 = "0"

PREFERRED_PROVIDER_u-boot-fw-utils_imx6ul-var-dart = "u-boot-fw-utils"
PREFERRED_RPROVIDER_u-boot-fw-utils_imx6ul-var-dart = "u-boot-fw-utils"
UBOOT_CONFIG_imx6ul-var-dart = "sd"
IMAGE_BOOTLOADER_FILE_imx6ul-var-dart = "u-boot-spl.img"
IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET_imx6ul-var-dart = "2"
MENDER_PARTITION_ALIGNMENT_KB_imx6ul-var-dart = "4096"
MENDER_STORAGE_DEVICE_imx6ul-var-dart = "/dev/mmcblk0"
MENDER_BOOT_PART_SIZE_MB_imx6ul-var-dart = "0"

# This naming of the mender recipes is for zeus and newer
BBMASK += "/meta-dmoseley-private/mender/recipes-mender/mender/mender-client_%.bbappend"
