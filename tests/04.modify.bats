#!/usr/bin/env bats

load pre

# Modify without username or avatar
@test "modify: --modify (should fail)" {
    run bash discord.sh --modify
    [ "${lines[0]}" = "fatal: must pass --username or --avatar with --modify" ]
    [ "$status" -eq 1 ]
}
# Modify with username
@test "modify: --modify --username --gnu-style <>" {
    run bash discord.sh --modify --username "Modify with username"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify ---username --gnu-style <>" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}
@test "modify: --modify --username --gnu-style=<>" {
    run bash discord.sh --modify --username="Modify with username"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify ---username --gnu-style=<>" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}
# Modify with avatar
@test "modify: --modify --avatar --gnu-style <>" {
    run bash discord.sh --modify --avatar "https://i.imgur.com/12jyR5Q.png"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify ---avatar --gnu-style <>" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}
@test "modify: --modify --avatar --gnu-style=<>" {
    run bash discord.sh --modify --avatar="https://i.imgur.com/12jyR5Q.png"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify ---avatar --gnu-style=<>" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}
# Modify with username and avatar
@test "modify: --modify --username --avatar --gnu-style <>" {
    run bash discord.sh --modify --username "Modify with username and avatar" --avatar "https://i.imgur.com/12jyR5Q.png"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify --username --avatar --gnu-style <>" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}
@test "modify: --modify --username --avatar --gnu-style=<>" {
    run bash discord.sh --modify --username "Modify with username and avatar" --avatar "https://i.imgur.com/12jyR5Q.png"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify --username --avatar --gnu-style=<>" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}
@test "modify: --modify --username --avatar --gnu-style varied" {
    run bash discord.sh --modify --username "Modify with username and avatar" --avatar="https://i.imgur.com/12jyR5Q.png"
    [ "$status" -eq 0 ]
}
@test "modify: verify --modify --username --avatar --gnu-style varied" {
    run bash discord.sh --text "verify"
    [ "$status" -eq 0 ]
}