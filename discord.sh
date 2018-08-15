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
        --tts) is_tts=1; shift;;

        --webhook-url=*) webhook_url=${1/--webhook-url=/''}; shift;;
        --webhook-url*) webhook_url=${2}; shift; shift;;

        --username=*) username=${1/--username=/''}; shift;;
        --username*) username=${2}; shift; shift;;

        --text=*) text=${1/--text=/''}; shift;;
        --text*) text=${2}; shift; shift;;

        --avatar-url=*) avatar_url=${1/--avatar-url=/''}; shift;;
        --avatar-url*) avatar_url=${2}; shift; shift;;

        # embed goodies

        --embed-title=*) embed_title=${1/--embed-title=/''}; shift;;
        --embed-title*) embed_title=${2}; shift; shift;;

        --embed-description=*) embed_description=${1/--embed-description=/''}; shift;;
        --embed-description*) embed_description=${2}; shift; shift;;

        --embed-url=*) embed_url=${1/--embed-url=/''}; shift;;
        --embed-url*) embed_url=${2}; shift; shift;;

        --embed-color=*) embed_color=${1/--embed-color=/''}; shift;;
        --embed-color*) embed_color=${2}; shift; shift;;

    esac
done

# set webhook url (if none exists after argument handling)
[[ -z ${webhook_url} ]] && [[ -n "${DISCORD_WEBHOOK}" ]] && webhook_url=${DISCORD_WEBHOOK}
[[ -z ${webhook_url} ]] && [[ -r "${webhook_file}" ]] && [[ -f "${webhook_file}" ]] && webhook_url=$(cat "${webhook_file}")

# no webhook could be found. bail out
[[ -z ${webhook_url} ]] && echo "fatal: no --webhook-url passed and no .webhook file to read from" && exit 1;


##
# build a raw message. output to stdout, to be captured by command substitution
##
build_message() {
    # ensure text is given
    [[ -z "${text}" ]] && echo "fatal: no text given" && exit 1

    # wait for confirmation from server
    local _wait="\"wait\": true"

    # these should already be set! we've checked above that they are
    [[ -n "${username}" ]] && local _username=", \"username\": \"${username}\""
    [[ -n "${text}" ]] && local _content=", \"content\": \"${text}\""
    [[ -n "${avatar_url}" ]] && local _avatar=", \"avatar_url\": \"${avatar_url}\""
    [[ -n "${is_tts}" ]] && local _tts=", \"tts\": true"

    # build message and echo
    local _json="${_username}${_content}${_avatar}${_tts}"
    echo "{ ${_wait}${_json} }"
}


##
# build an embed object, same as build_message, except this time with feeling
##
build_embed() {

    # need to have SOMETHING to build
    [[ -z "${embed_title}" ]] && \
        [[ -z "${embed_description}" ]] && \
        [[ -z "${embed_url}" ]] && \
        [[ -z "${embed_color}" ]] && \
        echo "fatal: nothing to embed" && exit 1

    # strip 0x prefix and convert hex to dec if necessary
    [[ -n "${embed_color}" ]] && [[ "${embed_color}" =~ ^0x[0-9a-fA-F]+$ ]] && embed_color=$(( 16#${embed_color/0x/''} ))

    # embed color must be an integer, if given
    [[ -n "${embed_color}" ]] && ! [[ "${embed_color}" =~ ^[0-9a-fA-F]+$ ]] && \
        echo "fatal: illegal color '${embed_color}'" && exit 1

    # let's build, boys
    [[ -n "${username}" ]] && local _username=", \"username\": \"${username}\""
    [[ -n "${avatar_url}" ]] && local _avatar=", \"avatar_url\": \"${avatar_url}\""
    [[ -n "${embed_title}" ]] && local _title=", \"title\": \"${embed_title}\""
    [[ -n "${embed_description}" ]] && local _desc=", \"description\": \"${embed_description}\""
    [[ -n "${embed_url}" ]] && local _url=", \"url\": \"${embed_url}\""
    [[ -n "${embed_color}" ]] && local _color=", \"color\": ${embed_color}"

    local _embedPrefix="\"nonce\": \"made with <3 by ChaoticWeg and Suce\""
    local _embed="[{ ${_embedPrefix}${_desc}${_url}${_color} }]"
    local _prefix="\"wait\": true, \"content\": \"${text}\"${_username}${_avatar}"
    echo "{ ${_prefix}, \"embeds\": ${_embed} }"
}

##
# send something to the text channel
##
send_something()
{
    # gotta send something
    [[ -z "${1}" ]] && echo "fatal: give me something to send" && exit 1

    # dry run?
    [[ -n ${is_dry} ]] && [[ "${is_dry}" -ne 0 ]] && echo "${_content}" && exit 0;

    # make the POST request and parse the results
    # results should be empty if there's no problem. otherwise, there should be code and message
    local _result

     _result=$(curl -H "Content-Type: application/json" -X POST "${webhook_url}" -d "${1}" 2>/dev/null)
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
    say) if ! _content=$(build_message); then echo "${_content}"; exit 1; else send_something "${_content}"; exit $?; fi;;
    embed) if ! _content=$(build_embed); then echo "${_content}"; exit 1; else send_something "${_content}"; exit $?; fi;;

    *) echo "fatal: unrecognized command '${cmd}'"; exit 1;;
esac

