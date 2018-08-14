#!/usr/bin/env bash

# assorted things (most of which should fail)
bats tests/etc.bats

# test 'say' command
bats tests/say.bats

