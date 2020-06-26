inherit cargo

DEPENDS += "dbus"
RDEPENDS_${PN} += " networkmanager dnsmasq iw "

SRC_URI += "git://github.com/balena-io/wifi-connect;protocol=https"
SRCREV = "9a1c8c7af699caea6beee50ba44b70909933d2a2"
S = "${WORKDIR}/git"
CARGO_SRC_DIR=""

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# please note if you have entries that do not begin with crate://
# you must change them to how that package can be fetched
SRC_URI += " \
crate://crates.io/aho-corasick/0.6.4 \
crate://crates.io/ansi_term/0.11.0 \
crate://crates.io/ascii/0.8.7 \
crate://crates.io/atty/0.2.10 \
crate://crates.io/base64/0.6.0 \
crate://crates.io/bitflags/1.0.3 \
crate://crates.io/bodyparser/0.8.0 \
crate://crates.io/buf_redux/0.6.3 \
crate://crates.io/byteorder/1.2.3 \
crate://crates.io/bytes/0.4.8 \
crate://crates.io/cfg-if/0.1.3 \
crate://crates.io/clap/2.31.2 \
crate://crates.io/dbus/0.5.4 \
crate://crates.io/dtoa/0.4.2 \
crate://crates.io/env_logger/0.4.3 \
crate://crates.io/error-chain/0.11.0 \
crate://crates.io/fuchsia-zircon-sys/0.3.3 \
crate://crates.io/fuchsia-zircon/0.3.3 \
crate://crates.io/futures-cpupool/0.1.8 \
crate://crates.io/futures/0.1.21 \
crate://crates.io/gcc/0.3.54 \
crate://crates.io/httparse/1.3.1 \
crate://crates.io/hyper/0.10.13 \
crate://crates.io/idna/0.1.4 \
crate://crates.io/iovec/0.1.2 \
crate://crates.io/iron-cors/0.7.1 \
crate://crates.io/iron/0.6.0 \
crate://crates.io/itoa/0.4.1 \
crate://crates.io/language-tags/0.2.2 \
crate://crates.io/lazy_static/1.0.1 \
crate://crates.io/libc/0.2.42 \
crate://crates.io/libdbus-sys/0.1.3 \
crate://crates.io/log/0.3.9 \
crate://crates.io/log/0.4.2 \
crate://crates.io/matches/0.1.6 \
crate://crates.io/memchr/1.0.2 \
crate://crates.io/memchr/2.0.1 \
crate://crates.io/mime/0.2.6 \
crate://crates.io/mime_guess/1.8.4 \
crate://crates.io/modifier/0.1.0 \
crate://crates.io/mount/0.4.0 \
crate://crates.io/multipart/0.13.6 \
crate://crates.io/network-manager/0.11.0 \
crate://crates.io/nix/0.10.0 \
crate://crates.io/num-bigint/0.1.44 \
crate://crates.io/num-complex/0.1.43 \
crate://crates.io/num-integer/0.1.39 \
crate://crates.io/num-iter/0.1.37 \
crate://crates.io/num-rational/0.1.42 \
crate://crates.io/num-traits/0.2.5 \
crate://crates.io/num/0.1.42 \
crate://crates.io/num_cpus/1.8.0 \
crate://crates.io/params/0.8.0 \
crate://crates.io/percent-encoding/1.0.1 \
crate://crates.io/persistent/0.4.0 \
crate://crates.io/phf/0.7.22 \
crate://crates.io/phf_codegen/0.7.22 \
crate://crates.io/phf_generator/0.7.22 \
crate://crates.io/phf_shared/0.7.22 \
crate://crates.io/pkg-config/0.3.11 \
crate://crates.io/plugin/0.2.6 \
crate://crates.io/proc-macro2/0.4.6 \
crate://crates.io/quote/0.6.3 \
crate://crates.io/rand/0.3.22 \
crate://crates.io/rand/0.4.2 \
crate://crates.io/redox_syscall/0.1.40 \
crate://crates.io/redox_termios/0.1.1 \
crate://crates.io/regex-syntax/0.5.6 \
crate://crates.io/regex/0.2.11 \
crate://crates.io/remove_dir_all/0.5.1 \
crate://crates.io/route-recognizer/0.1.12 \
crate://crates.io/router/0.6.0 \
crate://crates.io/rustc-serialize/0.3.24 \
crate://crates.io/safemem/0.2.0 \
crate://crates.io/sequence_trie/0.3.5 \
crate://crates.io/serde/1.0.66 \
crate://crates.io/serde_derive/1.0.66 \
crate://crates.io/serde_json/1.0.22 \
crate://crates.io/siphasher/0.2.2 \
crate://crates.io/slab/0.3.0 \
crate://crates.io/staticfile/0.5.0 \
crate://crates.io/strsim/0.7.0 \
crate://crates.io/syn/0.14.2 \
crate://crates.io/tempdir/0.3.7 \
crate://crates.io/termion/1.5.1 \
crate://crates.io/textwrap/0.9.0 \
crate://crates.io/thread_local/0.3.5 \
crate://crates.io/time/0.1.40 \
crate://crates.io/tokio-timer/0.1.2 \
crate://crates.io/traitobject/0.1.0 \
crate://crates.io/twoway/0.1.8 \
crate://crates.io/typeable/0.1.2 \
crate://crates.io/typemap/0.3.3 \
crate://crates.io/ucd-util/0.1.1 \
crate://crates.io/unicase/1.4.2 \
crate://crates.io/unicode-bidi/0.3.4 \
crate://crates.io/unicode-normalization/0.1.7 \
crate://crates.io/unicode-width/0.1.5 \
crate://crates.io/unicode-xid/0.1.0 \
crate://crates.io/unreachable/1.0.0 \
crate://crates.io/unsafe-any/0.4.2 \
crate://crates.io/url/1.7.0 \
crate://crates.io/urlencoded/0.6.0 \
crate://crates.io/utf8-ranges/1.0.0 \
crate://crates.io/vec_map/0.8.1 \
crate://crates.io/version_check/0.1.3 \
crate://crates.io/void/1.0.2 \
crate://crates.io/winapi-i686-pc-windows-gnu/0.4.0 \
crate://crates.io/winapi-x86_64-pc-windows-gnu/0.4.0 \
crate://crates.io/winapi/0.2.8 \
crate://crates.io/winapi/0.3.5 \
file://${PN}.service \
file://${PN}-startup.sh \
"

LIC_FILES_CHKSUM = "file://LICENSE;md5=3bfd34238ccc26128aef96796a8bbf97"

SUMMARY = "Easy WiFi setup for Linux devices from your mobile phone or laptop"
HOMEPAGE = "https://github.com/balena-io/wifi-connect"
LICENSE = "Apache-2.0"

do_install_append() {
  # Make sure JS and HTML bits get installed
  install -d ${D}${datadir}/${PN}
  cp -R ${S}/ui/ ${D}${datadir}/${PN}/ui/

  # Install systemd service script
  install -d ${D}${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/${PN}.service ${D}${systemd_unitdir}/system

  # Install startup scripts
  install -d ${D}${bindir}
  install -m 0755 ${WORKDIR}/${PN}-startup.sh ${D}${bindir}
}

FILES_${PN} += " \
    ${datadir}/${PN}/ui \
    ${systemd_unitdir}/system/${PN}.service \
"

inherit systemd
SYSTEMD_SERVICE_${PN} = " \
    ${PN}.service \
"
