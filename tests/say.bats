#!/usr/bin/env bats

@test "say: text, no username, --gnu-style=<>" {
    run bash discord.sh say --text="\`text, no username, --gnu-style=<>\`"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "say: text, no username, --gnu-style <>" {
    run bash discord.sh say --text "\`text, no username, --gnu-style <>\`"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "say: text, username, --gnu-style varied" {
    run bash discord.sh say --username "clever name" --text="\`text, username, --gnu-style varied\`"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "say: text, username, avatar, --gnu-style varied" {
    run bash discord.sh say --username "Peyton Manning" --text="OMAHA" --avatar-url "https://i.kym-cdn.com/photos/images/newsfeed/001/207/210/b22.jpg"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "say: no text (should fail)" {
    run bash discord.sh say 
    [ "$status" -eq 1 ]
    [ "$output" = "fatal: no text given" ]
}

@test "say: invalid webhook URL (should fail)" {
    skip "how the hell do we even handle this"
    run bash discord.sh say --text "how tf can you even see this?" --webhook-url "https://discordapp.com/api/webhooks/invalid/lol-no"
    [ "$status" -eq 0 ]
}

@test "say: malformed webhook URL (should fail)" {
    run bash discord.sh say --text "lol" --webhook-url "lol not a webhook"
    [ "$status" -eq 3 ]
    [ "$output" = "fatal: curl failed with code 3" ]
}

