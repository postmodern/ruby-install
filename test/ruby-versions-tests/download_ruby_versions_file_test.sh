#!/usr/bin/env bash

. ./test/helper.sh
. ./share/ruby-install/ruby-versions.sh

ruby="ruby"
file="stable.txt"
expected_path="$ruby_versions_dir/$ruby/$file"

function test_download_ruby_versions_file_with_no_parent_dir()
{
	rm -rf "$ruby_versions_dir/$ruby"

	download_ruby_versions_file "$ruby" "$file"

	assertTrue "did not create the parent dir" \
		   '[[ -d "$ruby_versions_dir/$ruby" ]]'
}

function test_download_ruby_versions_file_first_time()
{
	mkdir -p "$ruby_versions_dir/$ruby"

	download_ruby_versions_file "$ruby" "$file"

	assertTrue "did not create the file" \
		   '[[ -f "$expected_path" ]]'
	assertTrue "did not write data to the file" \
		   '[[ -s "$expected_path" ]]'
}

function test_download_ruby_versions_file_with_existing_file()
{
	mkdir -p "$ruby_versions_dir/$ruby"
	touch "$ruby_versions_dir/$ruby/$file"

	download_ruby_versions_file "$ruby" "$file"

	assertTrue "did not write data to the file" \
		   '[[ -s "$expected_path" ]]'
}

function tearDown()
{
	rm -rf "$ruby_versions_dir/$ruby"
}

SHUNIT_PARENT=$0 . $SHUNIT2
