. ./test/helper.sh
. ./share/ruby-install/checksums.sh

if   command -v md5sum >/dev/null; then md5sum="md5sum"
elif command -v md5    >/dev/null; then md5sum="md5"
fi

if   command -v sha1sum >/dev/null; then sha1sum="sha1sum"
elif command -v sha1    >/dev/null; then sha1sum="sha1"
fi

if   command -v sha256sum >/dev/null; then sha256sum="sha256sum"
elif command -v sha256    >/dev/null; then sha256sum="sha256"
fi

if   command -v sha512sum >/dev/null; then sha512sum="sha512sum"
elif command -v sha512    >/dev/null; then sha512sum="sha512"
fi

data="hello world"
file="./test/file.txt"

md5="5eb63bbbe01eeed093cb22bb8f5acdc3"
sha1="2aae6c35c94fcfb415dbe95f408b9ce91ee846ed"
sha256="b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9"
sha512="309ecc489c12d6eb4cc40f50c902f2b4d0ed77ee511a7c7a9bcd3ca86d4cd86f989dd35bc5ff499670da34255b45b0cfd830e81f605dcf7dc5542e93ae9cd76f"

checksums_md5="./test/checksums.md5"
checksums_sha1="./test/checksums.sha1"
checksums_sha256="./test/checksums.sha256"
checksums_sha512="./test/checksums.sha512"

function setUp()
{
	echo -n "$data" > "$file"

	cat <<EOS > "$checksums_md5"
eacf2ed066d1c5c3ba074cebb933d388  foo.txt
$md5  $(basename "$file")
4c80727cee7493fec3db112793d55221  bar.txt
EOS

	cat <<EOS > "$checksums_sha1"
3fd8717137c578f6ea05486c6c6c9b633e77a0ab  foo.txt
$sha1  $(basename "$file")
8203a446206c774b4673a62d1e92fd45df69c9b9  bar.txt
EOS

	cat <<EOS > "$checksums_sha256"
d8e6b6a5760ebae82c446f46441eeaee10d5034e8f0ec35871ecccaede7183e8  foo.txt
$sha256  $(basename "$file")
0610cff587f7eed38c5787ed880940c10efab6fd8ea92ebeeb00c1a6ae048119  bar.txt
EOS

	cat <<EOS > "$checksums_sha512"
879d5302f2041e0318b2e0f573e23c14f8022fcac4814ad74a59ab0a11456941f3476a0699e8bb5f84ca4c762d10a2fefe1f73e590e3b920b76079db4d326b52  foo.txt
$sha512  $(basename "$file")
a934e1875d4c38df432bc704265f0c16404bd06db96246aee85737b682bc0a0af6489177e703a5109448a837e1a48d43465a7ae0704d7a0a076b7438993bdb3f  bar.txt
EOS
}

function test_supported_checksums()
{
	assertEquals "did not detect the md5 checksum utilility" \
		     "md5:$md5sum" "${supported_checksums[0]}"

	assertEquals "did not detect the sha1 checksum utilility" \
		     "sha1:$sha1sum" "${supported_checksums[1]}"

	assertEquals "did not detect the sha256 checksum utilility" \
		     "sha256:$sha256sum" "${supported_checksums[2]}"

	assertEquals "did not detect the sha512 checksum utilility" \
		     "sha512:$sha512sum" "${supported_checksums[3]}"
}

function test_lookup_checksum_md5()
{
	assertEquals "did not return the expected md5 checksum" \
		     "$md5" \
		     "$(lookup_checksum "$checksums_md5" "$file")"
}

function test_lookup_checksum_sha1()
{
	assertEquals "did not return the expected sha1 checksum" \
		     "$sha1" \
		     "$(lookup_checksum "$checksums_sha1" "$file")"
}

function test_lookup_checksum_sha256()
{
	assertEquals "did not return the expected sha256 checksum" \
		     "$sha256" \
		     "$(lookup_checksum "$checksums_sha256" "$file")"
}

function test_lookup_checksum_sha512()
{
	assertEquals "did not return the expected sha512 checksum" \
		     "$sha512" \
		     "$(lookup_checksum "$checksums_sha512" "$file")"
}

function test_lookup_checksum_with_missing_file()
{
	assertEquals "returned data when it should not have" \
		     "" \
		     "$(lookup_checksum "$checksums_sha512" "missing.txt")"
}

function test_lookup_checksum_with_duplicate_entries()
{
	cat <<EOS > duplicate_checksums.md5
$md5  $(basename "$file")
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  $(basename "$file")
EOS

	assertEquals "did not return the first checksum for the file" \
		     "$md5" \
		     "$(lookup_checksum duplicate_checksums.md5 "$file")"

	rm duplicate_checksums.md5
}

function test_compute_checksum_md5()
{
	assertEquals "did not return the expected md5 checksum" \
		     "$md5" \
		     "$(compute_checksum "$md5sum" "$file")"
}

function test_compute_checksum_sha1()
{
	assertEquals "did not return the expected sha1 checksum" \
		     "$sha1" \
		     "$(compute_checksum "$sha1sum" "$file")"
}

function test_compute_checksum_sha256()
{
	assertEquals "did not return the expected sha256 checksum" \
		     "$sha256" \
		     "$(compute_checksum "$sha256sum" "$file")"
}

function test_compute_checksum_sha512()
{
	assertEquals "did not return the expected sha512 checksum" \
		     "$sha512" \
		     "$(compute_checksum "$sha512sum" "$file")"
}

function test_compute_checksum_with_missing_file()
{
	assertEquals "returned data when it should not have" \
		     "" \
		     "$(compute_checksum "$md5sum" "missing.txt")"
}

function test_verify_checksum_md5()
{
	verify_checksum "$checksums_md5" "$file" "$md5sum"

	assertEquals "checksum was not valid" 0 $?
}

function test_verify_checksum_sha1()
{
	verify_checksum "$checksums_sha1" "$file" "$sha1sum"

	assertEquals "checksum was not valid" 0 $?
}

function test_verify_checksum_sha256()
{
	verify_checksum "$checksums_sha256" "$file" "$sha256sum"

	assertEquals "checksum was not valid" 0 $?
}

function test_verify_checksum_sha512()
{
	verify_checksum "$checksums_sha512" "$file" "$sha512sum"

	assertEquals "checksum was not valid" 0 $?
}

function tearDown()
{
	rm "$file"
	rm "$checksums_md5" \
	   "$checksums_sha1" \
	   "$checksums_sha256" \
	   "$checksums_sha512"
}

SHUNIT_PARENT=$0 . $SHUNIT2
