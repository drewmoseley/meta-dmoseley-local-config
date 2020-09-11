require recipes-bsp/u-boot/u-boot-common.inc
require recipes-bsp/u-boot/u-boot.inc
        
SRCREV = "1afbb9f628e36aac36053a04ce9256bf05d2b7c9"
DEPENDS += "bc-native dtc-native"
SRC_URI_remove = "file://remove-redundant-yyloc-global.patch"
SRC_URI_append = " file://enable-squashfs.cfg "
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
DEFAULT_PREFERENCE = "-1"
