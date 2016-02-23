# bundle-standalone(1) -- bundles a package and its dependencies for standalone execution

## SYNOPSIS
`bundle-standalone`
`bundle-standalone` `-h`|`--help`<br>

## DESCRIPTION
`bundle-standalone` bundles a package and its dependencies into a single
directory from which the package can be used as is, standalone.

`bundle-dependencies` is used to resolve and download package dependencies into
the `standalone/packages` directory. Then, stubs are created for each of the
package's binaries in the `standalone/bin` directory. These stubs set the
necessary environment variables for the package to function as if it was
installed by a package manager.

## OPTIONS
* -h, --help:
  Show help text and exit.

## COPYRIGHT
`bash-common-bundle-dependencies` is Copyright (c) 2016 Vinson Chuong under The MIT License.

## SEE ALSO
bundle-dependencies(1)
