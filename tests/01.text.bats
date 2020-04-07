#!/usr/bin/env bats

load pre

# Text
@test "text: text, no username, --gnu-style=<>" {
    run bash discord.sh --text="text, no username, --gnu-style=<>"
    [ "$status" -eq 0 ]
}

@test "text: text, no username, --gnu-style <>" {
    run bash discord.sh --text "text, no username, --gnu-style <>"
    [ "$status" -eq 0 ]
}

# Username, text
@test "text: text, username, --gnu-style varied" {
    run bash discord.sh --username "username test" --text="text, username, --gnu-style varied"
    [ "$status" -eq 0 ]
}

# Username, avatar, text
@test "text: text, username, text, avatar, --gnu-style <>" {
    run bash discord.sh --username "avatar test" --text "avatar test" --avatar-url "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "text: text, username, text, avatar, --gnu-style=<>" {
    run bash discord.sh --username="avatar test" --text="avatar test" --avatar-url="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "text: text, username, text, avatar, --gnu-style varied" {
    run bash discord.sh --username "avatar test" --text="avatar test" --avatar-url "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

# Username, avatar, text, tts
@test "text: text, username, text, tts, avatar, --gnu-style <>" {
    run bash discord.sh --username "avatar test" --text "avatar test" --tts --avatar-url "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "text: text, username, text, tts, avatar, --gnu-style=<>" {
    run bash discord.sh --username="avatar test" --text="avatar test" --tts --avatar-url="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "text: text, username, text, tts, avatar, --gnu-style varied" {
    run bash discord.sh --username "avatar test" --text="avatar test" --tts --avatar-url "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

# Invalid/malformed webhooks
@test "text: invalid webhook URL (should fail)" {
    run bash discord.sh --text "how tf can you even see this?" --webhook-url "https://discordapp.com/api/webhooks/invalid/lol-no"
    [ "$status" -eq 1 ]
}

@test "text: malformed webhook URL (should fail)" {
    run bash discord.sh --text "lol" --webhook-url "lol not a webhook"
    [ "${lines[0]}" = "fatal: curl failed with code 3" ] || [ "${lines[0]}" = "fatal: curl failed with code 6" ]
    [ "$status" -eq 3 ] || [ "$status" -eq 6 ]
}

