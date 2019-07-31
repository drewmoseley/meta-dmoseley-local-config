FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://01_splash_mender_grub.cfg;subdir=git \
"

do_compile_prepend() {
    FASTBOOT="${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-fastboot', 'yes', 'no', d)}"

    # Determine the console settings
    case $MENDER_MACHINE:$FASTBOOT in
         *up-board*:no         ) CONSOLE_ARGS="console=ttyS0,115200n8 console=tty0";;
         *up-board*:yes        ) CONSOLE_ARGS="console=ttyS0,115200n8 quiet";;
         *intel-corei7-64*:no  ) CONSOLE_ARGS="console=ttyUSB0,115200n8 console=tty0";;
         *intel-corei7-64*:yes ) CONSOLE_ARGS="console=ttyUSB0,115200n8 quiet";;
         *beaglebone*:no       ) CONSOLE_ARGS="";;
         *beaglebone*:yes      ) CONSOLE_ARGS="quiet";;
         *:no                  ) bbwarn "Warning. Unknown machine configuration without fastboot, $MENDER_MACHINE";;
         *:yes                 ) bberror "Error. Unknown machine configuration with fastboot, $MENDER_MACHINE";;
    esac

    # Determine other bootargs
    case $MENDER_MACHINE in
        *up-board* ) EXTRA_BOOTARGS="biosdevname=0 net.ifnames=0";;
    esac

    echo "set console_bootargs=\"${CONSOLE_ARGS}\"" > ${S}/02_dmoseley_grub.cfg
    if [ -n "${EXTRA_BOOTARGS}" ]; then
        echo "set bootargs=\"\${bootargs} ${EXTRA_BOOTARGS}\"" >> ${S}/02_dmoseley_grub.cfg
    fi
}
