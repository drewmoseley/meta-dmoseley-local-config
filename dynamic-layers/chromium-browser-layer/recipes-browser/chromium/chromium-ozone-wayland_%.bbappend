require chromium-dmoseley.inc

do_configure:append() {
    RUST_LIB_PATH="${STAGING_LIBDIR_NATIVE}/rustlib/x86_64-unknown-linux-gnu/lib"
    
    # Add all Rust libraries
    cat >> ${S}/out/Release/args.gn <<EOF
extra_ldflags = "-L${RUST_LIB_PATH} -Wl,--push-state,--as-needed -lstd -lcompiler_builtins -Wl,--pop-state"
EOF
}