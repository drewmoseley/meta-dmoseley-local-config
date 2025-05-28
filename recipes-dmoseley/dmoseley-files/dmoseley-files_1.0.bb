SUMMARY = "Copy arbitrary user files to the dmoseley target image"
DESCRIPTION = "This recipe copies user-defined files from the build host into the image."
LICENSE = "MIT"

inherit useradd

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "-u 1000 -g 1000 -m -d /home/dmoseley dmoseley"
GROUPADD_PARAM:${PN} = "-g 1000 dmoseley"

DEPENDS += "rsync-native"
RDEPENDS:${PN} = "bash sed coreutils udev-extraconf perl"

# The target directory in the final image
do_install() {
	install -d ${D}/home/dmoseley/tezi
	rsync -avP --delete /work2/dmoseley/Toradex/Apalis* \
		  /work2/dmoseley/Toradex/Aquila* \
    	  /work2/dmoseley/Toradex/Colibri* \
    	  /work2/dmoseley/Toradex/Verdin* \
    	  --exclude=uuu --exclude=uuu_* --exclude=dfu-util --exclude=lib*.dll --exclude=recovery-windows* --exclude=*.exe \
		  ${D}/home/dmoseley/tezi/
	for dir in ${D}/home/dmoseley/tezi/*/recovery; do
		ln -s /usr/bin/uuu ${dir}/
		ln -s /usr/bin/dfu-util ${dir}/
	done

	cp ~/.aliases ~/.bash_functions ~/.bashrc ~/.bash_profile ~/.bash_prompt ~/.profile ${D}/home/dmoseley/
	install -d ${D}/home/dmoseley/SyncThing/mackup/bin
	for script in "inventory-serial-ports-local" "serial-term-local" "path_fix.pl"; do
		install -m 0755 ~/SyncThing/mackup/bin/$script ${D}/home/dmoseley/SyncThing/mackup/bin/
	done
	install -d -m 700 ${D}/home/dmoseley/.ssh
	install -m 600 /home/dmoseley/.ssh/id_rsa.pub ${D}/home/dmoseley/.ssh/authorized_keys
	chown -R 1000:1000 ${D}/home/dmoseley
}

FILES:${PN} = "/home/dmoseley"
