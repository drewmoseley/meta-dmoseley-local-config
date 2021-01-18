#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

mkdir -p /proc /sys /run /var/run
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs none /dev
mkdir /var/volatile/tmp

lighttpd -f /etc/lighttpd/lighttpd.conf &

exec /bin/sh
