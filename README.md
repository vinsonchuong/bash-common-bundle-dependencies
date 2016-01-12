# bash-common-bundle-dependencies
[![Build Status](https://travis-ci.org/vinsonchuong/bash-common-bundle-dependencies.svg?branch=master)](https://travis-ci.org/vinsonchuong/bash-common-bundle-dependencies)

Locally install package dependencies. This library is primarily meant for
enabling the use of Arch Linux packages hosted on GitHub in environments where
`pacman` is not available. It downloads and locally installs the dependencies
listed in the local `PKGBUILD` file.

Currently only AUR package dependencies structured as
[gitaur](https://github.com/vinsonchuong/gitaur) projects are supported.

* [docs](doc/bundle-dependencies.md)
* [code](bin/bundle-dependencies)

## Installing
If the target machine is running [Arch Linux](https://www.archlinux.org/),
an [AUR package](https://aur.archlinux.org/packages/bash-common-bundle-dependencies/)
is available.

Otherwise, the script in the `bin` directory can be executed directly.
