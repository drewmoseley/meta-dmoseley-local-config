require core-image-graphical.inc
IMAGE_INSTALL:append = " weston-xwayland "
IMAGE_INSTALL:append = " chromium-ozone-wayland "
IMAGE_INSTALL:remove:raspberrypi0 = " chromium-ozone-wayland "
IMAGE_INSTALL:remove:raspberrypi0-wifi = " chromium-ozone-wayland "
