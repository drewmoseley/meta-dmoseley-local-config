do_install:append () {
    echo "dmoseley ALL=(ALL) ALL" > ${D}${sysconfdir}/sudoers.d/001_dmoseley
}
