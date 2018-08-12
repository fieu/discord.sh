#!/usr/bin/env bash
#
# Discord.sh - Discord on command-line
# by ChaoticWeg and Suce

thisdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -eq 0 ]; then echo "fatal: no command given"; exit 1; fi

# source env file if exists
if [ -r "${thisdir}/.discord" ] && [ -f "${thisdir}/.discord" ]; then source ${thisdir}/.discord; fi

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

# set webhook url
[ -z ${webhook_url} ] && [ -r ".webhook" ] && [ -f ".webhook" ] && webhook_url=$(cat .webhook)
[ -z ${webhook_url} ] && echo "fatal: no --webhook-url passed and no .webhook file to read from" && exit 1;

build_message() {
    # ensure username and text are given
    [[ -z ${username// } ]] && echo "fatal: no username given" && exit 1
    [[ -z ${text// } ]] && echo "fatal: no text given" && exit 1

    # wait for confirmation from server
    local _wait="\"wait\": true"

    # these should already be set! we've checked above that they are
    [ -n "${username}" ] && local _username=", \"username\": \"${username}\""
    [ -n "${text}" ] && local _content=", \"content\": \"${text}\""

    # build message and echo
    local _json="${_username}${_content}"
    echo "{ ${_wait}${_json} }"
}

send_message()
{
    local _content=$(build_message)
    [ $? -ne 0 ] && exit 1;

    if [ -n "${is_dry}" ] && [ "${is_dry}" -ne 0 ]; then
        echo ${_content}
        return
    fi

    curl -H "Content-Type: application/json" -X POST ${webhook_url} -d "${_content}"
}

# process command
case "${cmd}" in
    say) send_message;;
    *) echo "fatal: unrecognized command '${cmd}'"; exit 1;;
esac

