#!/usr/bin/env bash

# TODO - automatically detect and run tests using builtins


# assorted things (most of which should fail)

echo -ne "\n  -- bats: tests/etc.bats\n\n"
bats tests/etc.bats

etc_code=$?
[[ "$etc_code" -ne 0 ]] && echo -ne "\n  -- FATAL: tests/etc.bats failed with code: ${etc_code}\n\n" && exit ${etc_code}


# test 'say' command

echo -ne "\n  -- bats: tests/say.bats\n\n"
bats tests/say.bats

say_code=$?
[[ "$say_code" -ne 0 ]] && echo -ne "\n  -- FATAL: tests/say.bats failed with code: ${say_code}\n\n" && exit ${say_code}


# all ok

echo -ne "\n  -- OK: all tests passed\n\n"
exit 0
