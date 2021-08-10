FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_up-squared = " file://01_splash_mender_grub.cfg;subdir=git "
SRC_URI_append_intel-corei7-64 = " file://01_splash_mender_grub.cfg;subdir=git "

do_compile_prepend() {
    FASTBOOT="${@bb.utils.contains('DMOSELEY_FEATURES', 'dmoseley-fastboot', 'yes', 'no', d)}"

    # Determine the console settings
    case $MENDER_MACHINE:$FASTBOOT in
         *up-squared*:no         ) CONSOLE_ARGS="console=ttyS0,115200n8 console=tty0";;
         *up-squared*:yes        ) CONSOLE_ARGS="console=ttyS0,115200n8 quiet";;
         *intel-corei7-64*:no  ) CONSOLE_ARGS="console=ttyUSB0,115200n8 console=tty0";;
         *intel-corei7-64*:yes ) CONSOLE_ARGS="console=ttyUSB0,115200n8 quiet";;
         *beaglebone*:no       ) CONSOLE_ARGS="console=tty0 console=ttyS0,115200n8";;
         *beaglebone*:yes      ) CONSOLE_ARGS="quiet";;
         *apalis*:no           ) CONSOLE_ARGS="console=ttymxc0,115200n8";;
         *apalis*:yes          ) CONSOLE_ARGS="quiet";;
         *colibri*:no          ) CONSOLE_ARGS="console=ttymxc0,115200n8";;
         *colibri*:yes         ) CONSOLE_ARGS="quiet";;
         *imx6ul-var-dart*:no  ) CONSOLE_ARGS="console=ttymxc0,115200n8";;
         *imx6ul-var-dart*:yes ) CONSOLE_ARGS="quiet";;
         *imx8mn-var-som*:no   ) CONSOLE_ARGS="console=ttymxc3,115200n8 earlycon=ec_imx6q,0x30a60000,115200";;
         *imx8mn-var-som*:yes  ) CONSOLE_ARGS="quiet";;
         *imx8mm-var-dart*:no  ) CONSOLE_ARGS="console=ttymxc0,115200n8 earlycon=ec_imx6q,0x30860000,115200";;
         *imx8mm-var-dart*:yes ) CONSOLE_ARGS="quiet";;
         *imx8*evk*:no         ) CONSOLE_ARGS="console=ttymxc1,115200n8 earlycon=ec_imx6q,0x30890000,115200";;
         *imx8*evk*:yes        ) CONSOLE_ARGS="quiet";;
         *:no                  ) bbwarn "Warning. Unknown machine configuration without fastboot, $MENDER_MACHINE";;
         *:yes                 ) bberror "Error. Unknown machine configuration with fastboot, $MENDER_MACHINE";;
    esac

    # Determine other bootargs
    case $MENDER_MACHINE in
        *intel-corei7-64* | up-squared ) EXTRA_BOOTARGS="biosdevname=0 net.ifnames=0";;
    esac

    echo "set console_bootargs=\"${CONSOLE_ARGS}\"" > ${S}/02_dmoseley_grub.cfg
    if [ -n "${EXTRA_BOOTARGS}" ]; then
        echo "set bootargs=\"\${bootargs} ${EXTRA_BOOTARGS}\"" >> ${S}/02_dmoseley_grub.cfg
    fi
}
