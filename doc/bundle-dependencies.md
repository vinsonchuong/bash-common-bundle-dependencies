# bundle-dependencies(1) -- locally installs PKGBUILD dependencies

## SYNOPSIS
`bundle-dependencies`
`bundle-dependencies` `-h`|`--help`<br>

## DESCRIPTION
`bundle-dependencies` installs all dependencies listed in the `PKGBUILD` file
in the current directory.

All of the packages listed in the `depends`, `optdepends`, `makedepends`, and
`checkdepends` keys will be installed. In addition, the `bats-git` package will
also be bundled.

Packages will be installed as subdirectories of `packages`. Symlinks to their
executable files will be created in `packages/bin`.

If `clidoc` is installed, the `build` function of each package will also be
run.

## OPTIONS
* -h, --help:
  Show help text and exit.

## COPYRIGHT
`bash-common-bundle-dependencies` is Copyright (c) 2016 Vinson Chuong under The MIT License.
