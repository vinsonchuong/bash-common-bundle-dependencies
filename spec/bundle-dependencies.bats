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
		echo "if [[ "$*" = \$* ]]; then" 
		cat
		echo 'fi'
	} >> "${STUB_DIR}/${command}"
	chmod +x "${STUB_DIR}/${command}"
}

pkgbuild() {
	mkdir "$PACKAGE_DIR"
	cat > "${PACKAGE_DIR}/PKGBUILD"
}

@test 'lists all of the immediate dependencies of the project' {
  pkgbuild <<-EOF
	depends=('dependency1' 'dependency2')
	optdepends=('opt1' 'opt2')
	makedepends=('make1' 'make2')
	checkdepends=('check1' 'check2')
	EOF

	cd "$PACKAGE_DIR"
	run bundle-dependencies
	[[ $status = 0 ]]
	[[ $output = *'Bundling: dependency1'* ]]
	[[ $output = *'Bundling: dependency2'* ]]
	[[ $output = *'Bundling: opt1'* ]]
	[[ $output = *'Bundling: opt2'* ]]
	[[ $output = *'Bundling: make1'* ]]
	[[ $output = *'Bundling: make2'* ]]
	[[ $output = *'Bundling: check1'* ]]
	[[ $output = *'Bundling: check2'* ]]
}

@test 'has default makedepends and checkdepends' {
  pkgbuild <<-EOF
	depends=('dependency1' 'dependency2')
	optdepends=('opt1' 'opt2')
	EOF

	cd "$PACKAGE_DIR"
	run bundle-dependencies
	[[ $status = 0 ]]
	[[ $output = *'Bundling: clidoc'* ]]
	[[ $output = *'Bundling: bats-git'* ]]
}
