do_compile_prepend() {
    if ! ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','true','false',d)}; then
        mv ${WORKDIR}/boot.cmd.in ${WORKDIR}/boot.cmd.in.dmoseley
        cat ${WORKDIR}/boot.cmd.in.dmoseley | awk '
             /chosen bootargs/ { print; print "setenv bootargs console=tty1 ${bootargs}" }
           ! /chosen bootargs/ {print}
           ' > ${WORKDIR}/boot.cmd.in
    fi
}
