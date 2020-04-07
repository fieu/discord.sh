#!/usr/bin/env bats

load pre

# Unknown command/flags
@test "etc: unknown command (should fail)" {
    run bash discord.sh invalid_command
    [ "${lines[0]}" = "fatal: unknown argument 'invalid_command'" ]
    [ "$status" -eq 1 ]
}
@test "etc: unknown flag (should fail)" {
    run bash discord.sh --invalid_flag
    [ "${lines[0]}" = "fatal: unknown argument '--invalid_flag'" ]
    [ "$status" -eq 1 ]
}

# Valid file upload
@test "etc: valid file --gnu-style <>" {
    run bash discord.sh --text="valid file --gnu-style <>" --file README.md
    [ "$status" -eq 0 ]
}

@test "etc: valid file --gnu-style=<>" {
    run bash discord.sh --text="valid file --gnu-style=<>" --file=README.md
    [ "$status" -eq 0 ]
}

# Invalid file upload
@test "etc: invalid file --gnu-style <> (should fail)" {
    run bash discord.sh --text="invalid file --gnu-style <>" --file invalid.file
    [ "${lines[0]}" = "fatal: curl exited with code 26 when sending file \"invalid.file\"" ]
    [ "$status" -eq 0 ]
}

@test "etc: invalid file --gnu-style=<> (should fail)" {
    run bash discord.sh --text="invalid file --gnu-style=<>" --file=invalid.file
    [ "${lines[0]}" = "fatal: curl exited with code 26 when sending file \"invalid.file\"" ]
    [ "$status" -eq 0 ]
}

@test "etc: invalid file --gnu-style varied (should fail)" {
    run bash discord.sh --text "invalid file --gnu-style=<>" --file=invalid.file
    [ "${lines[0]}" = "fatal: curl exited with code 26 when sending file \"invalid.file\"" ]
    [ "$status" -eq 0 ]
}

# Invalid payload (embed with file)
@test "etc: invalid payload (file + embed) --gnu-style <> (should fail)" {
    run bash discord.sh --description "Test description" --file README.md
    [ "${lines[0]}" = "fatal: files must be sent on their own (i.e. without text or embeds)" ]
    [ "$status" -eq 3 ]
}

@test "etc: invalid payload (file + embed) --gnu-style=<> (should fail)" {
    run bash discord.sh --description="Test description" --file=README.md
    [ "${lines[0]}" = "fatal: files must be sent on their own (i.e. without text or embeds)" ]
    [ "$status" -eq 3 ]
}

@test "etc: invalid payload (file + embed) --gnu-style varied (should fail)" {
    run bash discord.sh --description "Test description" --file=README.md
    [ "${lines[0]}" = "fatal: files must be sent on their own (i.e. without text or embeds)" ]
    [ "$status" -eq 3 ]
}