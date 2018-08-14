#!/usr/bin/env bash

for filename in tests/*.bats; do
    echo -ne "\n  -- bats: ${filename}\n\n"

    bats "${filename}"
    exitcode=$?

    [[ "${exitcode}" -ne 0 ]] && \
        echo -ne "\n  -- FATAL: ${filename} failed with code: ${exitcode}\n\n" && \
        exit ${exitcode}
done

# all ok

echo -ne "\n  -- OK: all tests passed\n\n"

