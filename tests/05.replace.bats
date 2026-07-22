#!/usr/bin/env bats

load pre

# Clean up any message-ID files created by these tests
teardown() {
    rm -f .discord_msg_bats_test .discord_msg_bats_test_eq
}

# --replace stores the returned message ID in .discord_msg_<key>
@test "replace: --replace --gnu-style <>" {
    run bash discord.sh --replace bats_test --text "replace, --gnu-style <>"
    [ "$status" -eq 0 ]
    [ -f .discord_msg_bats_test ]
    [ -s .discord_msg_bats_test ]
}

@test "replace: --replace --gnu-style=<>" {
    run bash discord.sh --replace=bats_test_eq --text "replace, --gnu-style=<>"
    [ "$status" -eq 0 ]
    [ -f .discord_msg_bats_test_eq ]
    [ -s .discord_msg_bats_test_eq ]
}

# A second run with the same key deletes the previous message and posts a new one
@test "replace: --replace re-run replaces previous message" {
    run bash discord.sh --replace bats_test --text "replace, first message"
    [ "$status" -eq 0 ]
    [ -f .discord_msg_bats_test ]
    first_id="$(cat .discord_msg_bats_test)"

    run bash discord.sh --replace bats_test --text "replace, second message"
    [ "$status" -eq 0 ]
    [ -f .discord_msg_bats_test ]
    second_id="$(cat .discord_msg_bats_test)"

    # The stored ID should be refreshed to the newly-sent message
    [ -n "$second_id" ]
    [ "$first_id" != "$second_id" ]
}
