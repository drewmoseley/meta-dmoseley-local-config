require core-image-graphical.inc
IMAGE_INSTALL:append = " chromium-x11 "
IMAGE_INSTALL:remove:raspberrypi0 = " chromium-x11 "
IMAGE_INSTALL:remove:raspberrypi0-wifi = " chromium-x11 "
