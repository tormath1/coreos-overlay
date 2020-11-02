This is a fork of Gentoo's sys-apps/coreutils package. There are two
reasons for having it here:

- Drop support for python 3.8 we haven't yet packaged.

- Disable split-usr USE flag. In our case /usr/bin and /bin are the
  same - the latter is the symlink to the former.
