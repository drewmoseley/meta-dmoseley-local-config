FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Currently supporting the pyro and morty branches.
# Not needed for master

SRC_URI_append  = " \
        file://0001-rootnfs-Working-rootnfs-using-connman.patch \
"
