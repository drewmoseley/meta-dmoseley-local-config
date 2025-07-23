DMOSELEY_FEATURES = "dmoseley-setup dmoseley-systemd dmoseley-wifi dmoseley-labnetworks dmoseley-users"
OVERRIDES =. "dmoseley-setup:"

python() {
    # Add all possible dmoseley-local features here.
    # Each one will also define the same string in OVERRIDES.
    dmoseley_local_features = {
        'dmoseley-setup',                # Basic setup -- flag for conditional settings
        'dmoseley-busybox',              # Use busybox for system initialization and dev management
        'dmoseley-sysvinit',             # Use sysvinit for system initialization and dev management
        'dmoseley-systemd',              # Use systemd for system initialization and dev management
        'dmoseley-networkd',             # Use systemd-networkd
        'dmoseley-networkmanager',       # Use networkmanager
        'dmoseley-connman',              # Use connman
        'dmoseley-wifi',                 # Use wifi and install device firmware blobs
        'dmoseley-localntp',             # Use a custom local NTP server
        'dmoseley-access-point',         # Enable access point mode
        'dmoseley-fastboot',             # Fastboot mode
        'dmoseley-persistent-logs',      # Enable persistent storage for all logs
        'dmoseley-readonly',             # Use readonly
        'dmoseley-labnetworks',          # Connect to caribbean-Lab
        'dmoseley-homenetworks',         # Connect to caribbean
        'dmoseley-passwordless',         # Disable all password based logins; assumes ssh key-based authentication
        'dmoseley-ptest',                # Enable all ptest configs
        'dmoseley-users',                # Enable extra users and passwords
        'dmoseley-board-farm-controller' # Settings for the board-farm-controller
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
    networkManagersConfigured=""
    for networkManager in [ "networkd", "networkmanager", "connman", "busybox" ]:
        if bb.utils.contains('DMOSELEY_FEATURES', "dmoseley-" + networkManager, True, False, d):
            numberOfNetworkManagersConfigured += 1
            networkManagersConfigured += " " + networkManager
    if (numberOfNetworkManagersConfigured != 1):
        bb.fatal("Must specify exactly one network manager: %s." % networkManagersConfigured)

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkd', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building networkd without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-connman', True, False, d) and \
       not bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', True, False, d):
        bb.fatal("Building connman without systemd is not supported.")

    if bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-access-point', True, False, d) and \
       bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-networkmanager', False, True, d):
        bb.fatal("Building access-point requires networkmanager.")
}

OVERRIDES:prepend = "${@'dmoseley-qemu:' if d.getVar('MACHINE',True).startswith('qemu') else ''}"
DMOSELEY_FEATURES:remove:dmoseley-qemu = " dmoseley-wifi "
DISTRO_FEATURES:remove:dmoseley-qemu = " wifi "

IMAGE_INSTALL:append:dmoseley-systemd = " systemd-analyze "
IMAGE_INSTALL:append:dmoseley-networkd = " wpa-supplicant "
IMAGE_INSTALL:append:dmoseley-connman = " connman connman-client connman-conf "
IMAGE_INSTALL:append:dmoseley-networkmanager = " networkmanager "

DISTRO_FEATURES:append:dmoseley-wifi = " wifi "
# Add wifi for beaglebone since we will use either a bbb wireless or a USB dongle
MACHINE_FEATURES:append:dmoseley-wifi:beaglebone-yocto = " wifi "
MACHINE_FEATURES:append:dmoseley-wifi:beaglebone = " wifi "
IMAGE_INSTALL:append:dmoseley-wifi = " \
    ${@bb.utils.contains('MACHINE', 'beaglebone-yocto', 'linux-firmware-wl18xx kernel-module-wl18xx ti-18xx-wlconf linux-firmware-mt76x2 linux-firmware-ralink linux-firmware-rtl8188 linux-firmware-rtl8192ce linux-firmware-rtl8192cu linux-firmware-rtl8192su', '', d)} \
    ${@bb.utils.contains('MACHINE', 'beaglebone', 'wl18xx-fw wlconf linux-firmware-wlcommon linux-firmware-mt76x2 linux-firmware-ralink linux-firmware-rtl8188 linux-firmware-rtl8192ce linux-firmware-rtl8192cu linux-firmware-rtl8192su', '', d)} \
    ${@bb.utils.contains('MACHINE', 'beagleplay', 'wl18xx-fw wlconf linux-firmware-wlcommon ', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi0', 'linux-firmware-ralink linux-firmware-rtl8188 linux-firmware-rtl8821', '', d)} \
    ${@bb.utils.contains('MACHINE', 'intel-corei7-64', 'kernel-module-rtl8xxxu linux-firmware-rtl8188', '', d)} \
    ${@bb.utils.contains('MACHINE', 'raspberrypi2', 'linux-firmware-rtl8192cu', '', d)} \
    ${@bb.utils.contains('MACHINE', 'orange-pi-zero', 'xradio-firmware xradio', '', d)} \
"

DTB_FILES:prepend:beaglebone-yocto = " am335x-boneblack-wireless.dtb am335x-pocketbeagle.dtb "
DTB_FILES:remove:beaglebone-yocto = " am335x-bone.dtb am335x-bonegreen.dtb "

# Enable selected init system
require ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-sysvinit', 'conf/distro/include/init-manager-sysvinit.inc', '', d)}
require ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-busybox', 'conf/distro/include/init-manager-mdev-busybox.inc', '', d)}
require ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-systemd', 'conf/distro/include/init-manager-systemd.inc', '', d)}

WIFI_IFACE ?= "wlan0"

# Cleanup FSTYPES
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

DMOSELEY_LOCAL_NTP_ADDRESS ??= "192.168.7.41"

# Multimedia licensing
LICENSE_FLAGS_ACCEPTED:append = " commercial "

# RPI specifics
RPI_USE_U_BOOT:rpi = "1"
ENABLE_UART:rpi = "1"
DISABLE_OVERSCAN:rpi = "1"
DISABLE_SPLASH:rpi = "1"
BOOT_DELAY:rpi = "0"
BOOT_DELAY_MS:rpi = "0"
WKS_FILE:rpi = "sdimage-raspberrypi-dmoseley.wks"
DISABLE_RPI_BOOT_LOGO:rpi:dmoseley-fastboot = "1"
RPI_EXTRA_CONFIG:rpi:append = " \nlcd_rotate=2\n "
VIDEO_CAMERA:rpi = "1"
# RASPBERRYPI_CAMERA_V2:rpi = "1"
# RASPBERRYPI_CAMERA_V3:rpi = "1"
IMAGE_INSTALL:append:rpi = " libcamera-apps "
SDIMG_ROOTFS_TYPE:rpi = "ext4"
LICENSE_FLAGS_ACCEPTED:append:rpi = " synaptics-killswitch "

# Other packages to install in _all_ images
IMAGE_INSTALL:append = " kernel-image kernel-modules kernel-devicetree "
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
IMAGE_INSTALL:remove:genericarm64 = "kernel-devicetree"
IMAGE_INSTALL:append = " libnss-mdns "
IMAGE_INSTALL:append = " nano "
IMAGE_INSTALL:append = " strace "
IMAGE_INSTALL:append = " parted "
IMAGE_INSTALL:append = " v4l-utils "
IMAGE_INSTALL:append = " lshw "
IMAGE_INSTALL:append = " zram "

IMAGE_INSTALL:append:dmoseley-board-farm-controller = " picocom "
IMAGE_INSTALL:append:dmoseley-board-farm-controller = " uuu dfu-util "
IMAGE_INSTALL:append:dmoseley-board-farm-controller = " rsync bzip2 libusb1 "

EXTRA_IMAGE_FEATURES += "package-management"
EXTRA_IMAGE_FEATURES += "allow-root-login post-install-logging ${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-users', '', 'allow-empty-password empty-root-password', d)}"

PACKAGE_FEED_URIS = "http://192.168.17.41:5678"

# Now install all of packagegroup-base which pulls in things from MACHINE_EXTRA_RDEPENDS and
# MACHINE_EXTRA_RRECOMMENDS.  This is not included by default in core-image-minimal and
# core-image-full-cmdline but it has some handy packages so let's include it by default.
# If certain builds are size constrained this (as well as package-management) should be
# removed.
IMAGE_INSTALL:append = " packagegroup-base "

add_dmoseley_data() {
   local buildhost=$(hostname)
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
IMAGE_FEATURES:append:intel-corei7-64 = " hwcodecs "

# Disable console on VT/FB
USE_VT:dmoseley-fastboot = "0"

DISTRO_FEATURES:append = " egl opengl wayland pam "
PACKAGECONFIG:append:pn-qemu-system-native = " sdl gtk+ virglrenderer epoxy "
PACKAGECONFIG:append:pn-nativesdk-qemu = " sdl gtk+ virglrenderer epoxy "

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


# Check for CVEs
# inherit cve-check

GRUB_SPLASH_IMAGE_FILE ?= "Max.tga"

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

#
# Settings for Toradex boards
#
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
PREFERRED_PROVIDER_u-boot:toradex = "u-boot-toradex"
PREFERRED_PROVIDER_virtual/bootloader:toradex = "u-boot-toradex"
PREFERRED_PROVIDER_virtual/dtb:toradex = "device-tree-overlays"
DISTROOVERRIDES:append:toradex = ":tdx"
TORADEX_BSP_VERSION = "toradex-bsp-6.2.0"
TEZI_STORAGE_DEVICE:apalis-imx6 = "mmcblk0"
# Meta-virtualization brings this in but it doesn't work with linux-toradex
KERNEL_FEATURES:remove:toradex = "cfg/virtio.scc"
WIFI_IFACE:toradex:dmoseley-systemd = "wlp1s0"
WIFI_IFACE:apalis-imx6 = ""
WIFI_IFACE:toradex:dmoseley-connman = "mlan0"
WIFI_IFACE:toradex:dmoseley-networkmanager = "wlp1s0"
XSERVER_DRIVER:remove:toradex:mx8 = "xf86-video-imx-vivante"

# Default for HDMI
DMOSELEY_DISPLAY_RESOLUTION ?= "1920x1080"
DMOSELEY_DISPLAY_RESOLUTION:colibri-imx7-emmc ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION:rpi ?= "800x480"
DMOSELEY_DISPLAY_RESOLUTION:intel-corei7-64 ?= "800x600"

ACCEPT_FSL_EULA = "1"

# Readonly settings
EXTRA_IMAGE_FEATURES:append:dmoseley-readonly = " read-only-rootfs "

# Enable splash screen (psplash)
IMAGE_FEATURES:append:dmoseley-fastboot = " splash "
PACKAGECONFIG:pn-sysvinit = "psplash-text-updates"
QB_KERNEL_CMDLINE_APPEND:dmoseley-fastboot = " quiet vt.global_cursor_default=0 "
APPEND:append:dmoseley-fastboot = " quiet vt.global_cursor_default=0 "
QB_KERNEL_CMDLINE_APPEND:append = " net.ifnames=0 "
APPEND:append = " net.ifnames=0 "

# Make sure VFAT partition labels are not too long
BOOTDD_VOLUME_ID:orange-pi-pc = "o-pi-pc"

# Log processing
FILESYSTEM_PERMS_TABLES:remove:dmoseley-persistent-logs =  "files/fs-perms-volatile-log.txt"

# Set wpebackend
PREFERRED_PROVIDER_virtual/wpebackend = "wpebackend-fdo"
PREFERRED_RPROVIDER_virtual/wpebackend = "wpebackend-fdo"

inherit image-buildinfo

DISTRO_FEATURES:append:dmoseley-ptest = " ptest "
EXTRA_IMAGE_FEATURES:append:dmoseley-ptest = " ptest-pkgs "

DISTRO_FEATURES:append = " virtualization "
IMAGE_INSTALL:append = " docker ca-certificates "

BB_GENERATE_MIRROR_TARBALLS ?= "0"
BB_GENERATE_SHALLOW_TARBALLS ?= "0"
BB_GIT_SHALLOW ?= "1"
BB_GIT_SHALLOW_DEPTH ?= "1"

inherit extrausers
PASSWD:dmoseley-users = "\$5\$4/wE9jXZFsGpfAnm\$WbyvhYsSMQZ0LK/33Zg6fE4muwUNG2n2pzuHuIsrAV0"
EXTRA_USERS_PARAMS:dmoseley-users = "\
    usermod -p '${PASSWD}' -G docker,dialout dmoseley; \
    usermod -p '${PASSWD}' root; \
    "
IMAGE_INSTALL:append:dmoseley-users = " dmoseley-files "

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