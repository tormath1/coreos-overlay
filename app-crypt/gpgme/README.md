# gpgme package

This was added as a dependency of libpod, which ships `podman`. It's in
coreos-overlay since gpgme compile-time tests are broken on systemd systems and
lead to access violations during build. We therefore explicitly disable
compile-time testing in the build recipes.
