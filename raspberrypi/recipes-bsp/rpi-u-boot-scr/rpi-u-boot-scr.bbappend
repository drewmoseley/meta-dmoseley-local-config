do_compile_prepend() {
    EXTRA_CONSOLE_ARGS=""
    if ${@bb.utils.contains('DMOSELEY_FEATURES','dmoseley-fastboot','true','false',d)}; then
        EXTRA_CONSOLE_ARGS="console=ttyS0,115200n8"
    else
        EXTRA_CONSOLE_ARGS="console=tty1 console=ttyS0,115200n8"
    fi
    mv ${WORKDIR}/boot.cmd.in ${WORKDIR}/boot.cmd.in.dmoseley
    cat ${WORKDIR}/boot.cmd.in.dmoseley | awk -v EXTRA_CONSOLE_ARGS="${EXTRA_CONSOLE_ARGS}" '
         /chosen bootargs/ { print; print "setenv bootargs " EXTRA_CONSOLE_ARGS " ${bootargs}" }
       ! /chosen bootargs/ { print }
      ' > ${WORKDIR}/boot.cmd.in
}
