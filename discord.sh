#!/usr/bin/env bash
#
# Discord.sh - Discord on command-line
# by ChaoticWeg and Suce

shopt -s lastpipe   # avoid subshell weirdness hopefully
shopt -so pipefail  # hopefully correctly get $? in substitution

thisdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# gotta have a command, boss
[ "$#" -eq 0 ] && echo "fatal: no command given" && exit 1

# source env file if exists
[ -r "${thisdir}/.discord" ] && [ -f "${thisdir}/.discord" ] && source ${thisdir}/.discord

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

# set webhook url (after argument handling)
[ -z ${webhook_url} ] && [ -n "${DISCORD_WEBHOOK}" ] && webhook_url=${DISCORD_WEBHOOK}
[ -z ${webhook_url} ] && [ -r ".webhook" ] && [ -f ".webhook" ] && webhook_url=$(cat .webhook)
[ -z ${webhook_url} ] && echo "fatal: no --webhook-url passed and no .webhook file to read from" && exit 1;


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
    [ -n "${username}" ] && local _username=", \"username\": \"${username}\""
    [ -n "${text}" ] && local _content=", \"content\": \"${text}\""

    # build message and echo
    local _json="${_username}${_content}"
    echo "{ ${_wait}${_json} }"
}


##
# send a message to the text channel
##
send_message()
{
    local _content=$(build_message)

    [[ $? -ne 0 ]] && echo ${_content} && exit 1      # bail out on build fail
    [[ -n ${is_dry} ]] && echo ${_content} && exit 0  # dry run

    curl -H "Content-Type: application/json" -X POST ${webhook_url} -d "${_content}"
    exit $?
}


##
# process command
##

case "${cmd}" in
    say) send_message && exit $?;;
    *) echo "fatal: unrecognized command '${cmd}'"; exit 1;;
esac

