DMOSELEY_FEATURES = "dmoseley-setup dmoseley-systemd dmoseley-wifi dmoseley-labnetworks"
OVERRIDES =. "dmoseley-setup:"

python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-setup',                # Basic setup -- flag for conditional settings
        'dmoseley-mender',               # Use mender
        'dmoseley-busybox',              # Use busybox for system initialization and dev management
        'dmoseley-sysvinit',             # Use sysvinit for system initialization and dev management
        'dmoseley-systemd',              # Use systemd for system initialization and dev management
        'dmoseley-networkd',             # Use systemd-networkd
        'dmoseley-networkmanager',       # Use networkmanager
        'dmoseley-connman',              # Use connman
        'dmoseley-wifi-connect',         # Use wifi-connect
        'dmoseley-wifi',                 # Use wifi and install device firmware blobs
        'dmoseley-localntp',             # Use a custom local NTP server
        'dmoseley-mender-prod-server',   # Use an on-prem deployment of the Mender production server
        'dmoseley-mender-demo-server',   # Use the standard Mender demo server from the canned integration environment
        'dmoseley-mender-hosted-server', # Use hosted Mender
        'dmoseley-mender-hosted-personal-account-server', # Use hosted Mender with drew@moseleynet.net account
        'dmoseley-mender-staging-server', # Use staging hosted Mender
        'dmoseley-mender-migrate-to-hosted',  # Migrate from production to hosted
        'dmoseley-partuuid',             # Use partuuids with Mender
        'dmoseley-access-point',         # Enable access point mode
        'dmoseley-fastboot',             # Fastboot mode
        'dmoseley-persistent-logs',      # Enable persistent storage for all logs
        'dmoseley-readonly',             # Use readonly
        'dmoseley-labnetworks',          # Connect to caribbean-Lab
        'dmoseley-homenetworks',         # Connect to caribbean
        'dmoseley-mobilenetworks',       # Connect to tethered and mobile networks
        'dmoseley-passwordless',         # Disable all password based logins; assumes ssh key-based authentication
    }

    for feature in d.getVar('DMOSELEY_FEATURES').split():
        if feature.startswith("dmoseley-"):
            if feature not in dmoseley_local_features:
                bb.fatal("%s from DMOSELEY_FEATURES is not a valid local feature."
                         % feature)
            d.setVar('OVERRIDES:append', ':%s' % feature)

    numberOfInitSystemsConfigured=0
    for initSystem in [ "busybox", "sysvinit", "systemd" ]:
        if bb.utils.contains('DMOSELEY_FEATURES', "dmoseley-" + initSystem, True, False, d):
            numberOfInitSystemsConfigured += 1
    if (numberOfInitSystemsConfigured != 1):
        bb.fatal("Must specify exactly one init system.")

    numberOfNetworkManagersConfigured=0
    for networkManager in [ "networkd", "networkmanager", "connman", "wifi-connect", "busybox" ]:
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

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-persistent-logs', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-readonly', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender', True, False, d):
        bb.fatal("Building with persistent logs and readonly root filesystem requires Mender.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender', True, False, d):
        numberOfServersConfigured=0
        for serverType in [ "demo-server", "prod-server", "hosted-server", "hosted-personal-account-server", "staging-server", "migrate-to-hosted" ]:
            if bb.utils.contains('DMOSELEY_FEATURES', "dmoseley-mender-" + serverType, True, False, d):
                numberOfServersConfigured += 1
        if (numberOfServersConfigured != 1):
            bb.fatal("Must specify exactly one server type.")
}


OVERRIDES:prepend = "${@'dmoseley-qemu:' if d.getVar('MACHINE',True).startswith('qemu') or d.getVar('MACHINE',True).startswith('vexpress-qemu') else ''}"
DMOSELEY_FEATURES:remove:dmoseley-qemu = " dmoseley-wifi "
DISTRO_FEATURES:remove:dmoseley-qemu = " wifi "

DMOSELEY_MENDER_BBCLASS:colibri-imx6ull = "mender-full-ubi"
DMOSELEY_MENDER_BBCLASS:vexpress-qemu-flash = "mender-full-ubi"
DMOSELEY_MENDER_BBCLASS:qemux86-64-bios = "mender-full-bios"
DMOSELEY_MENDER_BBCLASS = "mender-full"
inherit ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender', '${DMOSELEY_MENDER_BBCLASS}', '', d)}

IMAGE_INSTALL:append:dmoseley-connman = " connman connman-client connman-conf "
IMAGE_INSTALL:append:dmoseley-networkmanager = " networkmanager networkmanager-nmtui "
IMAGE_INSTALL:append:dmoseley-wifi-connect = " wifi-connect "

DISTRO_FEATURES:append:dmoseley-wifi = " wifi "
# Add wifi for beaglebone since we will use either a bbb wireless or a USB dongle
MACHINE_FEATURES:append:dmoseley-wifi:beaglebone-yocto = " wifi "
IMAGE_INSTALL:append:dmoseley-wifi = " \
    ${@bb.utils.contains('MACHINE', 'beaglebone-yocto', 'linux-firmware-wl18xx kernel-module-wl18xx linux-firmware-ralink linux-firmware-rtl8188 linux-firmware-rtl8192ce linux-firmware-rtl8192cu linux-firmware-rtl8192su', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi0', 'linux-firmware-ralink linux-firmware-rtl8188', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi2', 'linux-firmware-rtl8192cu', '', d)} \
"

KERNEL_DEVICETREE:prepend:beaglebone-yocto = " am335x-boneblack-wireless.dtb am335x-pocketbeagle.dtb "
KERNEL_DEVICETREE:remove:beaglebone-yocto = " am335x-bone.dtb am335x-bonegreen.dtb "
IMAGE_BOOT_FILES:append:beaglebone-yocto = " am335x-boneblack-wireless.dtb am335x-pocketbeagle.dtb "

# Enable selected init system
require ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-sysvinit', 'conf/distro/include/init-manager-sysvinit.inc', '', d)}
require ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-busybox', 'conf/distro/include/init-manager-mdev-busybox.inc', '', d)}
require ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', 'conf/distro/include/init-manager-systemd.inc', '', d)}

WIFI_IFACE ?= "wlan0"

# Explicitly remove wifi from qemu buids
DISTRO_FEATURES:remove:vexpress-qemu = "wifi"
DISTRO_FEATURES:remove:vexpress-qemu-flash = "wifi"
IMAGE_INSTALL:remove:vexpress-qemu = "iw wpa-supplicant"
IMAGE_INSTALL:remove:vexpress-qemu-flash = "iw wpa-supplicant"

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
    ${@bb.utils.contains("SOC_FAMILY", "rpi", "wic", "", d)} \
"
IMAGE_FSTYPES_REMOVE_COMMUNITY = " \
    ext3 \
    tar tar.bz2 tar.gz \
    ${@bb.utils.contains("MACHINE", "chip", "ext4", "", d)} \
    ${@bb.utils.contains("SOC_FAMILY", "rpi", "wic.bz2", "", d)} \
"

IMAGE_FSTYPES:append = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", " ${IMAGE_FSTYPES_APPEND_MENDER}", " ${IMAGE_FSTYPES_APPEND_COMMUNITY}", d)} "
IMAGE_FSTYPES:remove = "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", " ${IMAGE_FSTYPES_REMOVE_MENDER}", " ${IMAGE_FSTYPES_REMOVE_COMMUNITY}", d)}"

DMOSELEY_LOCAL_NTP_ADDRESS ??= "192.168.7.41"

# Setup Mender disk sizes
MENDER_BOOT_PART_SIZE_MB:rpi ??= "64"
MENDER_STORAGE_TOTAL_SIZE_MB:qemux86 ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB:qemux86-64 ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB:rpi ??= "2048"
MENDER_STORAGE_TOTAL_SIZE_MB:beaglebone-yocto ??= "1024"
MENDER_STORAGE_TOTAL_SIZE_MB:genericx86-64 ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB:genericx86 ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB:intel-corei7-64 ??= "4096"
MENDER_STORAGE_TOTAL_SIZE_MB:minnowboard ??= "3072"
MENDER_STORAGE_TOTAL_SIZE_MB:colibri-imx6ull = "512"
MENDER_STORAGE_PEB_SIZE:colibri-imx6ull = "131072"

# Multimedia licensing
LICENSE_FLAGS_ACCEPTED:append = " commercial "

# RPI specifics
RPI_USE_U_BOOT:rpi = "1"
ENABLE_UART:rpi = "1"
DISABLE_OVERSCAN:rpi = "1"
DISABLE_SPLASH:rpi = "1"
BOOT_DELAY:rpi = "0"
BOOT_DELAY_MS:rpi = "0"
DISABLE_RPI_BOOT_LOGO:rpi:dmoseley-fastboot = "1"
RPI_EXTRA_CONFIG:rpi:append = " \nlcd_rotate=2\n "
SDIMG_ROOTFS_TYPE:rpi = "ext4"
_MENDER_BOOTLOADER_DEFAULT:rpi = "mender-uboot"
LICENSE_FLAGS_ACCEPTED:append:rpi = " synaptics-killswitch "

# Other packages to install in _all_ images
IMAGE_INSTALL:append = " kernel-image kernel-modules kernel-devicetree "
IMAGE_INSTALL:remove:vexpress-qemu-flash = "kernel-image kernel-modules kernel-devicetree"
IMAGE_INSTALL:remove:qemuarm = "kernel-devicetree"
IMAGE_INSTALL:remove:qemuarm64 = "kernel-devicetree"
IMAGE_INSTALL:remove:intel-corei7-64 = "kernel-devicetree"
IMAGE_INSTALL:remove:minnowboard = "kernel-devicetree"
IMAGE_INSTALL:remove:riscv32 = "kernel-devicetree"
IMAGE_INSTALL:remove:riscv64 = "kernel-devicetree"
IMAGE_INSTALL:remove:qemux86 = "kernel-devicetree"
IMAGE_INSTALL:remove:qemux86-64 = "kernel-devicetree"
IMAGE_INSTALL:remove:genericx86 = "kernel-devicetree"
IMAGE_INSTALL:remove:genericx86-64 = "kernel-devicetree"
IMAGE_INSTALL:append = " libnss-mdns "
IMAGE_INSTALL:remove:vexpress-qemu = "libnss-mdns"
IMAGE_INSTALL:remove:vexpress-qemu-flash = "libnss-mdns"
IMAGE_INSTALL:append = " nano "

EXTRA_IMAGE_FEATURES:append = " package-management "
PACKAGE_FEED_URIS = "http://aruba.lab.moseleynet.net:5678"

# Now install all of packagegroup-base which pulls in things from MACHINE_EXTRA_RDEPENDS and
# MACHINE_EXTRA_RRECOMMENDS.  This is not included by default in core-image-minimal and
# core-image-full-cmdline but it has some handy packages so let's include it by default.
# If certain builds are size constrained this (as well as package-management) should be
# removed.
IMAGE_INSTALL:append = " packagegroup-base "
IMAGE_INSTALL:remove:vexpress-qemu-flash = "packagegroup-base"

# Mender settings
IMAGE_INSTALL:append = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", " drew-state-scripts mender-ipk", "", d)} "

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

# intel-corei7-64 Board extra settings
SERIAL_CONSOLE:append:intel-corei7-64 = " ttyUSB0 "
SERIAL_CONSOLES:append:intel-corei7-64 = " 115200;ttyUSB0 "
KERNEL_CONSOLE:intel-corei7-64 = "ttyUSB0"

# Disable console on VT/FB
USE_VT:dmoseley-fastboot = "0"

IMAGE_FEATURES += "hwcodecs"
DISTRO_FEATURES:append = " egl opengl wayland pam "
PACKAGECONFIG:append:pn-qemu-system-native = " sdl gtk+ virglrenderer glx "
PACKAGECONFIG:append:pn-nativesdk-qemu = " sdl gtk+ virglrenderer glx "

# Full versions of various utilities
IMAGE_INSTALL:append = " \
    bind-utils \
    coreutils \
    findutils \
    iputils-ping \
    iputils-tracepath \
    traceroute \
    iproute2 \
    iproute2-ss \
    less \
    ncurses-terminfo \
    net-tools \
    procps \
    util-linux \
"
IMAGE_INSTALL:remove:vexpress-qemu-flash = "image-display mender-binary-delta bind-utils iputils-tracepath"


# Check for CVEs
# inherit cve-check

GRUB_SPLASH_IMAGE_FILE ?= "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "Mender.tga", "Max.tga", d)}"

# I'm not sure why this cannot be calculated using bitbake variable inline python syntax
# but when I do it that way, and SB is not enabled then the expansion is not done and the
# shell eventually chokes on the unknown syntax.
python () {
    splashfile = d.getVar("GRUB_SPLASH_IMAGE_FILE")
    extension = d.getVar("SB_FILE_EXT")
    if extension is not None and extension != "":
        d.setVar("EFI_SECUREBOOT_BOOT_FILES", "%s%s unifont.pf2%s:EFI/BOOT/fonts/unifont.pf2%s" % (splashfile, extension, extension, extension))
    else:
        d.setVar("EFI_SECUREBOOT_BOOT_FILES", "")
}
IMAGE_BOOT_FILES:append:intel-corei7-64 = " \
    ${GRUB_SPLASH_IMAGE_FILE} \
    unifont.pf2;EFI/BOOT/fonts/unifont.pf2 \
    ${EFI_SECUREBOOT_BOOT_FILES} \
"

MENDER_FEATURES_ENABLE:append:dmoseley-mender = " mender-persist-systemd-machine-id "
MENDER_FEATURES_DISABLE:append:dmoseley-mender = " mender-growfs-data "

#
# Settings for Toradex boards
#

# We set this varible using this syntax rather than a proper override due to the order of operations.
# If we use an override, that does not get applied until after the logic in mender-setup-ubi which
# causes a parse failure. Unfortunately if we end up with more raw NAND boards this logic will
# need to be beefed up but fortunately that does not seem likely
MENDER_MTDIDS = "${@bb.utils.contains('MACHINE', 'colibri-imx6ull', 'nand0=gpmi-nand', '', d)}"

DISTROOVERRIDES:append:apalis-imx6 = ":upstream"
DISTROOVERRIDES:append:colibri-imx6 = ":upstream"
DISTROOVERRIDES:append:colibri-imx6ull = ":upstream"
DISTROOVERRIDES:append:colibri-imx6ull-emmc = ":upstream"
DISTROOVERRIDES:append:colibri-imx7 = ":upstream"
DISTROOVERRIDES:append:colibri-imx7-emmc = ":upstream"
IMX_DEFAULT_BSP:apalis-imx6 = "mainline"
IMX_DEFAULT_BSP:colibri-imx6 = "mainline"
IMX_DEFAULT_BSP:colibri-imx6ull = "mainline"
IMX_DEFAULT_BSP:colibri-imx6ull-emmc = "mainline"
IMX_DEFAULT_BSP:colibri-imx7 = "mainline"
IMX_DEFAULT_BSP:colibri-imx7-ennc = "mainline"
OVERRIDES:prepend = "${@'toradex:' if d.getVar('MACHINE',True).startswith('colibri') or d.getVar('MACHINE',True).startswith('apalis') or d.getVar('MACHINE',True).startswith('verdin') else ''}"
MACHINE_BOOT_FILES:remove:mender-grub:toradex = "boot.scr"
PREFERRED_PROVIDER_u-boot:toradex = "u-boot-toradex"
PREFERRED_PROVIDER_virtual/bootloader:toradex = "u-boot-toradex"
PREFERRED_PROVIDER_virtual/dtb:toradex = "device-tree-overlays"
IMAGE_TYPE_MENDER_TEZI=""
IMAGE_TYPE_MENDER_TEZI:toradex = "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "image_type_mender_tezi", "", d)}"
IMAGE_CLASSES:append = " ${IMAGE_TYPE_MENDER_TEZI} "
IMAGE_FSTYPES:append:toradex = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender_tezi", "", d)}"
TORADEX_INCLUDE_FILE=""
TORADEX_INCLUDE_FILE:toradex="conf/machine/include/${MACHINE}.inc"
TORADEX_INCLUDE_FILE:colibri-imx8x=""
TORADEX_INCLUDE_FILE:apalis-imx8x=""
TORADEX_INCLUDE_FILE:apalis-imx8=""
TORADEX_INCLUDE_FILE:verdin-imx8mm=""
TORADEX_INCLUDE_FILE:verdin-imx8mp=""
require ${TORADEX_INCLUDE_FILE}
DISTROOVERRIDES:append:toradex = ":tdx"
TORADEX_BSP_VERSION="toradex-bsp-6.2.0"
TORADEX_MENDER_CLASS=""
TORADEX_MENDER_CLASS:toradex="mender-toradex"
inherit ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-mender', '${TORADEX_MENDER_CLASS}', '', d)}
MENDER_STORAGE_DEVICE:apalis-imx6 = "/dev/mmcblk2"
TEZI_STORAGE_DEVICE:apalis-imx6 = "mmcblk0"
MENDER_UBOOT_STORAGE_DEVICE:apalis-imx6 = "0"
MENDER_STORAGE_DEVICE:colibri-imx7-emmc = "/dev/mmcblk0"
MENDER_UBOOT_STORAGE_DEVICE:colibri-imx7-emmc = "0"
MENDER_MTDPARTS:colibri-imx6ull = "gpmi-nand:512k(mx6ull-bcb),1536k(u-boot1)ro,1536k(u-boot2)ro,-(ubi)"
# Meta-virtualization brings this in but it doesn't work with linux-toradex
KERNEL_FEATURES:remove:toradex="cfg/virtio.scc"
_MENDER_BOOTLOADER_DEFAULT:toradex = "mender-uboot"
_MENDER_IMAGE_TYPE_DEFAULT:toradex = "${@bb.utils.contains_any('MACHINE','colibri-imx6ull','mender-image-ubi','mender-image-sd',d)}"
MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET:apalis-imx8 = "0"
MENDER_BOOT_PART_SIZE_MB:apalis-imx8 = "32"
OFFSET_SPL_PAYLOAD:apalis-imx8 = ""
MENDER_STORAGE_DEVICE:apalis-imx8 = "/dev/mmcblk0"
MENDER_STORAGE_TOTAL_SIZE_MB:apalis-imx8 = "12288"
WIFI_IFACE:toradex:dmoseley-systemd = "wlp1s0"
WIFI_IFACE:apalis-imx6 = ""
WIFI_IFACE:toradex:dmoseley-connman = "mlan0"
WIFI_IFACE:toradex:dmoseley-networkmanager = "wlp1s0"
XSERVER_DRIVER:remove:toradex:mx8="xf86-video-imx-vivante"

# Default for HDMI
DMOSELEY_DISPLAY_RESOLUTION ?= "1920x1080"
DMOSELEY_DISPLAY_RESOLUTION:colibri-imx7-emmc ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION:rpi ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION:intel-corei7-64 ?= "800x600"

# Mender Commercial settings
IMAGE_INSTALL:append:arm = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender-binary-delta", "", d)}"
IMAGE_INSTALL:append:aarch64 = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender-binary-delta", "", d)}"
IMAGE_INSTALL:append:x86-64 = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "mender-binary-delta", "", d)}"
LICENSE_FLAGS_ACCEPTED:append = " ${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-mender", "commercial_mender-yocto-layer-license", "", d)}"
SRC_URI:pn-mender-binary-delta = "file:///work2/dmoseley/mender-binary-delta/mender-binary-delta-1.4.1.tar.xz"


ACCEPT_FSL_EULA = "1"

# Readonly settings
EXTRA_IMAGE_FEATURES:append:dmoseley-readonly = " read-only-rootfs "

# Enable splash screen (psplash)
IMAGE_FEATURES:append:dmoseley-fastboot = " splash "
PACKAGECONFIG:pn-sysvinit = "psplash-text-updates"
QB_KERNEL_CMDLINE_APPEND:dmoseley-fastboot = " quiet vt.global_cursor_default=0 "

# Make sure VFAT partition labels are not too long
BOOTDD_VOLUME_ID:orange-pi-pc = "o-pi-pc"

# Log processing
VOLATILE_LOG_DIR = "${@bb.utils.contains("DMOSELEY_FEATURES", "dmoseley-persistent-logs", "no", "yes", d)}"

# Graphical QEMU
PACKAGECONFIG:append:pn-qemu-system-native = " sdl"
PACKAGECONFIG:append:pn-nativesdk-qemu = " sdl"

# Set wpebackend
PREFERRED_PROVIDER_virtual/wpebackend = "wpebackend-fdo"
PREFERRED_RPROVIDER_virtual/wpebackend = "wpebackend-fdo"

# Mender partUUID
# Random UUID's generated using the 'uuidgen -r' command
MENDER_FEATURES_ENABLE:append:dmoseley-partuuid = " mender-partuuid "
MENDER_BOOT_PART:dmoseley-partuuid = "/dev/disk/by-partuuid/b81ffd37-7d11-443a-8891-05e88ee63212"
MENDER_ROOTFS_PART_A:dmoseley-partuuid = "/dev/disk/by-partuuid/30cd164a-f210-414e-acee-261caeadf9dc"
MENDER_ROOTFS_PART_B:dmoseley-partuuid = "/dev/disk/by-partuuid/69e4bb57-1f5e-4c9b-b9ae-534eaa0f632f"
MENDER_DATA_PART:dmoseley-partuuid = "/dev/disk/by-partuuid/46c92b29-30cf-4572-9a73-d80ed802c26e"

inherit image-buildinfo

MENDER_ARTIFACT_SIGNING_KEY = "/work/dmoseley/local/mender-artifact-signing-private.key"

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