# bundle-dependencies(1) -- locally installs PKGBUILD dependencies

## SYNOPSIS
`bundle-dependencies`
`bundle-dependencies` `-h`|`--help`<br>

## DESCRIPTION
`bundle-dependencies` installs all dependencies listed in the `PKGBUILD` file
in the current directory.

All of the packages listed in the `depends`, `optdepends`, `makedepends`, and
`checkdepends` keys will be installed. If a `makedepends` array is not
provided, it will be assumed to be `makedepends=('clidoc')`. If a 'checkdepends'
array is not provided, it will be assumed to be `checkdepends=('bats-git')`

Packages will be installed as subdirectories of `packages`. Symlinks to their
executable files will be created in `packages/bin`.

## OPTIONS
* -h, --help:
  Show help text and exit.

## COPYRIGHT
`bash-common-bundle-dependencies` is Copyright (c) 2016 Vinson Chuong under The MIT License.
