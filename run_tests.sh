#!/usr/bin/env bash

total_exitcode=0
export DISCORD_WEBHOOK="$DISCORD_WEBHOOK_URL"

for filename in tests/*.bats; do
    echo -ne "\n  -- bats: ${filename}\n\n"

    bats "${filename}"
    exitcode=$?

    [[ "${exitcode}" -ne 0 ]] && \
        echo -ne "\n  -- FATAL: ${filename} failed with code: ${exitcode}\n\n" && \
        total_exitcode="${exitcode}"
done

# all done

[[ "${total_exitcode}" -eq 0 ]] && echo -ne "\n  -- OK: all tests passed\n\n" && exit 0;
echo -ne "\n  -- FATAL: one or more tests failed\n\n" && exit $total_exitcode;

