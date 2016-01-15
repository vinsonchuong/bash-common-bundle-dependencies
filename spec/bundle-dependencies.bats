#!/usr/bin/env bats

setup() {
	export PACKAGE_DIR="${BATS_TMPDIR}/package"
	export STUB_DIR="${BATS_TMPDIR}/stub"
	export PATH="$STUB_DIR:$PATH"
}

teardown() {
	rm -rf "$PACKAGE_DIR" "$STUB_DIR"
}

stub() {
	mkdir -p "$STUB_DIR"
	command=$1
	shift
	{
		echo "if [[ '$*' = \$* ]]; then"
		cat
		echo 'fi'
	} >> "${STUB_DIR}/${command}"
	chmod +x "${STUB_DIR}/${command}"
}

pkgbuild() {
	mkdir "$PACKAGE_DIR"
	cat > "${PACKAGE_DIR}/PKGBUILD"
}

@test 'recursively lists the dependencies of a package' {
  pkgbuild <<-BASH
	depends=('p1')
	BASH

	stub curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p1' <<-BASH
	cat <<-EOF
	depends=('p2' 'p3')
	EOF
	BASH

	stub curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p2' <<-BASH
	cat <<-EOF
	depends=('p4')
	EOF
	BASH

	stub curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p3' <<-BASH
	cat <<-EOF
	depends=('p4')
	EOF
	BASH

	stub curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p4' <<-BASH
	cat <<-EOF
	depends=()
	EOF
	BASH

	cd "$PACKAGE_DIR"
	run bundle-dependencies
	[[ $status = 0 ]]
	[[ $output = *'Bundling: p1'* ]]
	[[ $output = *'Bundling: p2'* ]]
	[[ $output = *'Bundling: p3'* ]]
	[[ $output = *'Bundling: p4'* ]]

	[[ $output != *'p1'*'p1'* ]]
	[[ $output != *'p2'*'p2'* ]]
	[[ $output != *'p3'*'p3'* ]]
	[[ $output != *'p4'*'p4'* ]]
}

@test 'has default makedepends and checkdepends' {
	pkgbuild <<-EOF
	depends=('dependency1' 'dependency2')
	optdepends=('opt1' 'opt2')
	EOF

	stub curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=clidoc' <<-BASH
	echo
	BASH

	stub curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=bats-git' <<-BASH
	echo
	BASH

	cd "$PACKAGE_DIR"
	run bundle-dependencies
	[[ $status = 0 ]]
	[[ $output = *'Bundling: clidoc'* ]]
	[[ $output = *'Bundling: bats-git'* ]]
}
