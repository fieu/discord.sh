#!/usr/bin/env bats

@test "etc: unknown command (should fail)" {
    run bash discord.sh aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    [ "$status" -eq 1 ]
    # not even gonna try to parse output on this one. exit code 1 is enough honestly
}

