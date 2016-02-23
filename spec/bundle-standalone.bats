#!/usr/bin/env bats

teardown() {
	rm -rf "${BATS_TMPDIR}/prototypical" "${BATS_TMPDIR}/project"
}

@test 'bundles the current package into standalone/' {
	cd "$BATS_TMPDIR"
	run git clone 'https://github.com/vinsonchuong/prototypical'
	cd "${BATS_TMPDIR}/prototypical"

	run bundle-standalone
	[[ $status = 0 ]]

	[[ -d "${BATS_TMPDIR}/prototypical/standalone/bin" ]]
	ls -lha "${BATS_TMPDIR}/prototypical/standalone/bin"

	export PATH="${BATS_TMPDIR}/prototypical/standalone/bin:$PATH"

	run prototypical base 'project'
	echo "$output"
	[[ $status = 0 ]]
	[[ -f "${BATS_TMPDIR}/prototypical/project/LICENSE" ]]

	run prototypical --help
	[[ $status = 0 ]]
	[[ $output = *'A starting point for a project'* ]]
}
