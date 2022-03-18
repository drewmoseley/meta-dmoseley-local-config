DEPENDS:append:toradex = "\
        at-spi2-atk \
"

# gbm is availiable only for mx8
GN_ARGS_append_mx6 = " use_system_minigbm=false "
