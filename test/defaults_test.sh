#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	defaults
}

SHUNIT_PARENT=$0 . $SHUNIT2
