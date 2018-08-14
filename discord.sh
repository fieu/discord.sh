#!/usr/bin/env bash
#
# Discord.sh - Discord on command-line
# by ChaoticWeg and Suce

shopt -s lastpipe   # avoid subshell weirdness hopefully
shopt -so pipefail  # hopefully correctly get $? in substitution

thisdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
webhook_file="${thisdir}/.webhook"

# gotta have a command, boss
[[ "$#" -eq 0 ]] && echo "fatal: no command given" && exit 1

# grab command
cmd="${1}"; shift;

# gather arguments
while (( "$#" )); do
    case "${1}"  in
        --dry-run) is_dry=1; shift;;
        --webhook-url=*) webhook_url=${1/--webhook-url=/''}; shift;;
        --username=*) username=${1/--username=/''}; shift;;
        --text=*) text=${1/--text=/''}; shift;;
    esac
done

# set webhook url (if none exists after argument handling)
[[ -z ${webhook_url} ]] && [[ -n "${DISCORD_WEBHOOK}" ]] && webhook_url=${DISCORD_WEBHOOK}
[[ -z ${webhook_url} ]] && [[ -r "${webhook_file}" ]] && [[ -f "${webhook_file}" ]] && webhook_url=$(cat "${webhook_file}")

# no webhook could be found. bail out
[[ -z ${webhook_url} ]] && echo "fatal: no --webhook-url passed and no .webhook file to read from" && exit 1;


##
# build the message. output to stdout, to be captured by command substitution
##
build_message() {
    # ensure username and text are given
    [[ -z ${username// } ]] && echo "fatal: no username given" && exit 1
    [[ -z ${text// } ]] && echo "fatal: no text given" && exit 1

    # wait for confirmation from server
    local _wait="\"wait\": true"

    # these should already be set! we've checked above that they are
    [[ -n "${username}" ]] && local _username=", \"username\": \"${username}\""
    [[ -n "${text}" ]] && local _content=", \"content\": \"${text}\""

    # build message and echo
    local _json="${_username}${_content}"
    echo "{ ${_wait}${_json} }"
}


##
# send a message to the text channel
##
send_message()
{
    local _content  # initialize _content, to avoid obscuring exit code of build_message below
    if ! _content=$(build_message); then echo "${_content}"; exit 1; fi

    # dry run?
    [[ -n ${is_dry} ]] && [[ "${is_dry}" -ne 0 ]] && echo "${_content}" && exit 0;

    # make the POST request and parse the results
    # results should be empty if there's no problem. otherwise, there should be code and message
    local _result

     _result=$(curl -H "Content-Type: application/json" -X POST "${webhook_url}" -d "${_content}" 2>/dev/null)
     send_ok=$?
     [[ "${send_ok}" -ne 0 ]] && echo "fatal: curl failed with code ${send_ok}" && exit $send_ok

     _result=$(echo "${_result}" | jq '.')

    # if we have a result, there was a problem. echo and exit.
    [[ -n ${_result} ]] && \
        echo error: "$(echo "${_result}" | jq .message)" \("$(echo "${_result}" | jq .code)"\) && \
        exit 1

    exit 0
}


##
# process command
##

case "${cmd}" in
    say) send_message && exit $?;;
    *) echo "fatal: unrecognized command '${cmd}'"; exit 1;;
esac

