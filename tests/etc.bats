#!/usr/bin/env bats

@test "etc: no command (should fail)" {
    run bash discord.sh
    [ "$status" -eq 1 ]
    [ "$output" = "fatal: no command given" ]
}

@test "etc: unknown command (should fail)" {
    run bash discord.sh aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    [ "$status" -eq 1 ]
}

