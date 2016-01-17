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

@test 'recursively resolves the dependencies of a package' {
  pkgbuild <<-BASH
	depends=('p1')
	BASH

	stub curl -sfL 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=bats-git' <<-BASH
	cat <<-EOF
	depends=()
	source=('https://example.com/package.tar.gz')
	EOF
	BASH

	stub curl -sfL 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p1' <<-BASH
	cat <<-EOF
	depends=('p2' 'p3')
	source=('https://example.com/package.tar.gz')
	EOF
	BASH

	stub curl -sfL 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p2' <<-BASH
	cat <<-EOF
	depends=('p4')
	source=('https://example.com/package.tar.gz')
	EOF
	BASH

	stub curl -sfL 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p3' <<-BASH
	cat <<-EOF
	depends=('p4')
	source=('https://example.com/package.tar.gz')
	EOF
	BASH

	stub curl -sfL 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=p4' <<-BASH
	cat <<-EOF
	depends=()
	source=('https://example.com/package.tar.gz')
	EOF
	BASH

	stub curl -sfL 'https://example.com/package.tar.gz' <<-BASH
	tar -czT /dev/null
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

@test 'bundles bats-git by default' {
	pkgbuild <<-EOF
	depends=()
	EOF

	cd "$PACKAGE_DIR"
	run bundle-dependencies
	[[ $status = 0 ]]
	[[ $output = *'Bundling: bats-git'* ]]
}

@test 'installs resolved dependencies' {
	pkgbuild <<-EOF
	depends=('bash-common-environment')
	EOF

	cd "$PACKAGE_DIR"
	run bundle-dependencies

	[[ -d "${PACKAGE_DIR}/packages/bin" ]]

	run "${PACKAGE_DIR}/packages/bin/environment" --help
	echo "$output"
	[[ $status = 0 ]]
	[[ $output = *'sets common environment variables for a Bash library'* ]]

	[[ -x "${PACKAGE_DIR}/packages/bin/parse-options" ]]
	[[ -x "${PACKAGE_DIR}/packages/bin/bats" ]]
}
