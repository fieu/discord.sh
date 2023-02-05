#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
auto-changelog -t "$DIR/changelog-template.hbs" -l 999 --starting-version "$(git describe --abbrev=0)" --stdout --sort-commits date-desc --hide-credit