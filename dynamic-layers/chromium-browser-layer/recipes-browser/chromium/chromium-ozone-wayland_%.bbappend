DEPENDS:append:toradex = "\
        at-spi2-atk \
"

GN_ARGS:append = " use_wayland_gbm=false "
GN_ARGS:append:mx6 = " use_system_minigbm=false "
