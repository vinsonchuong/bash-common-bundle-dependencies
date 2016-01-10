#!/usr/bin/env bats

@test 'it says hello world' {
	run bin/bundle-dependencies
	[[ $status = 0 ]]
	[[ $output = *'Hello World!'* ]]
}
