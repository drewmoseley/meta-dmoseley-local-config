PACKAGES =+ "${PN}-mt76xxx"

FILES:${PN}-mt76xxx = " \
  ${nonarch_base_libdir}/firmware/mt7662_rom_patch.bin \
  ${nonarch_base_libdir}/firmware/mt7662.bin \
  ${nonarch_base_libdir}/firmware/mediatek/mt7662_rom_patch.bin \
  ${nonarch_base_libdir}/firmware/mediatek/mt7662.bin \
"
