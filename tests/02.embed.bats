#!/usr/bin/env bats

load pre

# Empty  (various empty tests)
@test "embed: empty title --gnu-style <> (should fail)" {
    run bash discord.sh --title ""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

@test "embed: empty title --gnu-style=<> (should fail)" {
    run bash discord.sh --title=""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

@test "embed: empty description --gnu-style <> (should fail)" {
    run bash discord.sh --description ""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

@test "embed: empty description --gnu-style=<> (should fail)" {
    run bash discord.sh --description=""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

@test "embed: empty title, description --gnu-style <> (should fail)" {
    run bash discord.sh --title "" --description ""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

@test "embed: empty title, description --gnu-style=<> (should fail)" {
    run bash discord.sh --title="" --description=""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

@test "embed: empty title, description --gnu-style varied (should fail)" {
    run bash discord.sh --title="" --description ""
    [ "${lines[0]}" = "fatal: nothing to build" ]
    [ "$status" -eq 1 ]
}

# Title
@test "embed: title --gnu-style <>" {
    run bash discord.sh --title "Test title"
    [ "$status" -eq 0 ]
}

@test "embed: title --gnu-style=<>" {
    run bash discord.sh --title="Test title"
    [ "$status" -eq 0 ]
}

# Description
@test "embed: description --gnu-style <>" {
    run bash discord.sh --description "Test description"
    [ "$status" -eq 0 ]
}
@test "embed: description --gnu-style=<>" {
    run bash discord.sh --description="Test description"
    [ "$status" -eq 0 ]
}

# Title, description
@test "embed: title, description --gnu-style <>" {
    run bash discord.sh --title "Test title" --description "Test description"
    [ "$status" -eq 0 ]
}

@test "embed: title, description --gnu-style=<>" {
    run bash discord.sh --title="Test title" --description="Test description"
    [ "$status" -eq 0 ]
}

@test "embed: title, description --gnu-style varied" {
    run bash discord.sh --title="Test title" --description "Test description"
    [ "$status" -eq 0 ]
}

# Title, description, color
@test "embed: title, description, color --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF"
    [ "$status" -eq 0 ]
}

# Title, description, color, url
@test "embed: title, description, color, url --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author
@test "embed: title, description, color, url, author --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url
@test "embed: title, description, color, url, author, author-url --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url, author-icon
@test "embed: title, description, color, url, author, author-url, author-icon --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url, author-icon, image
@test "embed: title, description, color, url, author, author-url, author-icon, image --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon, image --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon, image --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url, author-icon, image, thumbnail
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image="https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url, author-icon, image, thumbnail, footer
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail "https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image="https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer="Test footer"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail "https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer" \
        --footer-icon "https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image="https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer="Test footer" \
        --footer-icon="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer" \
        --footer-icon="https://i.imgur.com/o96JZ1Y.png"
    [ "$status" -eq 0 ]
}

# Title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail "https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer" \
        --footer-icon "https://i.imgur.com/o96JZ1Y.png" \
        --timestamp
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image="https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer="Test footer" \
        --footer-icon="https://i.imgur.com/o96JZ1Y.png" \
        --timestamp
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer" \
        --footer-icon="https://i.imgur.com/o96JZ1Y.png" \
        --timestamp
    [ "$status" -eq 0 ]
}
# Title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp, field
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp, fields --gnu-style <>" {
    run bash discord.sh \
        --title "Test title" \
        --description "Test description" \
        --color "0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author "Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon "https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail "https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer" \
        --footer-icon "https://i.imgur.com/o96JZ1Y.png" \
        --timestamp \
        --field "Name;Value;false" \
        --field "Foo;Bar"
    [ "$status" -eq 0 ]
}

@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp, fields --gnu-style=<>" {
    run bash discord.sh \
        --title="Test title" \
        --description="Test description" \
        --color="0xFFFFFF" \
        --url="https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url="https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image="https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer="Test footer" \
        --footer-icon="https://i.imgur.com/o96JZ1Y.png" \
        --timestamp \
        --field="Name;Value;false" \
        --field "Foo;Bar"
    [ "$status" -eq 0 ]
}
@test "embed: title, description, color, url, author, author-url, author-icon, image, thumbnail, footer, footer-icon, timestamp, fields --gnu-style varied" {
    run bash discord.sh \
        --title="Test title" \
        --description "Test description" \
        --color="0xFFFFFF" \
        --url "https://github.com/ChaoticWeg/discord.sh" \
        --author="Test author" \
        --author-url "https://github.com/ChaoticWeg/discord.sh" \
        --author-icon="https://i.imgur.com/o96JZ1Y.png" \
        --image "https://i.imgur.com/o96JZ1Y.png" \
        --thumbnail="https://i.imgur.com/o96JZ1Y.png" \
        --footer "Test footer" \
        --footer-icon="https://i.imgur.com/o96JZ1Y.png" \
        --timestamp \
        --field "Name;Value;false" \
        --field="Foo;Bar"
    [ "$status" -eq 0 ]
}