do_compile_prepend() {
    echo 'CONFIG_USB_ETHER_RTL8152=y' >> ${S}/configs/${UBOOT_MACHINE}
}
