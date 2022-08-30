IMAGE_INSTALL:append = " wpewebkit cog gst-examples mesa-demos phoronix-test-suite "
IMAGE_INSTALL:remove:beaglebone-yocto = " wpewebkit cog "
IMAGE_INSTALL:remove:raspberrypi0 = " wpewebkit cog "
IMAGE_INSTALL:remove:raspberrypi0-wifi = " wpewebkit cog "
