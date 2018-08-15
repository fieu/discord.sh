#!/usr/bin/env bash
#
# Discord.sh - Discord on command-line
# by ChaoticWeg and Suce

shopt -s lastpipe   # avoid subshell weirdness hopefully
shopt -so pipefail  # hopefully correctly get $? in substitution

get_ts() { echo "$(date -u --iso-8601=seconds)"; }

thisdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
webhook_file="${thisdir}/.webhook"

# HELP TEXT PLEASE
[[ "$#" -eq 0 ]] && echo "help text goes here" && exit 0

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

        --avatar=*) avatar_url=${1/--avatar=/''}; shift;;
        --avatar*) avatar_url=${2}; shift; shift;;

        # embed goodies

        --title=*) embed_title=${1/--title=/''}; embedding=1; shift;;
        --title*) embed_title=${2}; embedding=1; shift; shift;;

        --description=*) embed_description=${1/--description=/''}; embedding=1; shift;;
        --description*) embed_description=${2}; embedding=1; shift; shift;;

        --url=*) embed_url=${1/--url=/''}; embedding=1; shift;;
        --url*) embed_url=${2}; embedding=1; shift; shift;;

        --color=*) embed_color=${1/--color=/''}; embedding=1; shift;;
        --color*) embed_color=${2}; embedding=1; shift; shift;;

        --timestamp*) embed_timestamp=1; shift;;

        # embed author

        --author-name=*) embed_authorname=${1/--author-name=/''}; embedding=1; shift;;
        --author-name*) embed_authorname=${2}; embedding=1; shift; shift;;

        --author-url=*) embed_authorurl=${1/--author-url=/''}; embedding=1; shift;;
        --author-url*) embed_authorurl=${2}; embedding=1; shift; shift;;

        --author-icon=*) embed_authoricon=${1/--author-icon=/''}; embedding=1; shift;;
        --author-icon*) embed_authoricon=${2}; embedding=1; shift; shift;;

        # unknown argument. bail out

        *) echo "fatal: unknown argument '${1}'"; exit 1;;

    esac
done

# set webhook url (if none exists after argument handling)
[[ -z ${webhook_url} ]] && [[ -n "${DISCORD_WEBHOOK}" ]] && webhook_url=${DISCORD_WEBHOOK}
[[ -z ${webhook_url} ]] && [[ -r "${webhook_file}" ]] && [[ -f "${webhook_file}" ]] && webhook_url=$(cat "${webhook_file}")

# no webhook could be found. bail out
[[ -z ${webhook_url} ]] && echo "fatal: no --webhook-url passed and no .webhook file to read from" && exit 1;


##
# build embed author object
##
build_author() {
    # don't build if not embedding
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    [[ -n "${embed_authorname}" ]] && local _name=", \"name\": \"${embed_authorname}\""
    [[ -n "${embed_authorurl}" ]] && local _url=", \"url\": \"${embed_authorurl}\""
    [[ -n "${embed_authoricon}" ]] && local _icon=", \"icon_url\": \"${embed_authoricon}\""

    echo ", \"author\": { \"placeholder\": \"hello\"${_name}${_url}${_icon} }"
}


##
# build an embed object
##
build_embed() {
    # should we embed? if not, bail out without error
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    [[ -n "${embed_title}" ]] && local _title=", \"title\": \"${embed_title}\""
    [[ -n "${embed_description}" ]] && local _desc=", \"description\": \"${embed_description}\""
    [[ -n "${embed_url}" ]] && local _url=", \"url\": \"${embed_url}\""
    [[ -n "${embed_color}" ]] && local _color=", \"color\": ${embed_color}"
    [[ -n "${embed_timestamp}" ]] && [[ "${embed_timestamp}" -eq 1 ]] && local _ts=", \"timestamp\": \"$(get_ts)\""

    local _author="$(build_author)"

    echo ", \"embeds\": [{ \"top\": \"kek\"${_title}${_desc}${_url}${_color}${_ts}${_author} }]"
}


build() {

    # need to have SOMETHING to build
    [[ -z "${text}" ]] && \
        [[ -z "${embed_title}" ]] && \
        [[ -z "${embed_description}" ]] && \
            echo "fatal: nothing to build" && exit 1

    # strip 0x prefix and convert hex to dec if necessary
    [[ -n "${embed_color}" ]] && [[ "${embed_color}" =~ ^0x[0-9a-fA-F]+$ ]] && embed_color="$(( ${embed_color} ))"

    # embed color must be an integer, if given
    [[ -n "${embed_color}" ]] && ! [[ "${embed_color}" =~ ^[0-9]+$ ]] && \
        echo "fatal: illegal color '${embed_color}'" && exit 1

    # let's build, boys

    [[ -n "${text}" ]] && local _content=", \"content\": \"${text}\""
    [[ -n "${username}" ]] && local _username=", \"username\": \"${username}\""
    [[ -n "${avatar_url}" ]] && local _avatar=", \"avatar_url\": \"${avatar_url}\""
    [[ -n "${embedding}" ]] && local _embed="$(build_embed)"

    local _prefix="\"wait\": true${_content}${_username}${_avatar}${_embed}"

    echo "{ ${_prefix}${_embed} }"
}

##
# send something to the text channel
##
send()
{
    # gotta send something
    [[ -z "${1}" ]] && echo "fatal: give me something to send" && exit 1;

    local _sendme="${1}"

    # dry run?
    [[ -n "${is_dry}" ]] && [[ "${is_dry}" -ne 0 ]] && echo "${1}" && exit 0;

    # make the POST request and parse the results
    # results should be empty if there's no problem. otherwise, there should be code and message
    local _result

     _result=$(curl -H "Content-Type: application/json" -X POST "${webhook_url}" -d "${_sendme}" 2>/dev/null)
     send_ok=$?
     [[ "${send_ok}" -ne 0 ]] && echo "fatal: curl failed with code ${send_ok}" && exit $send_ok

     _result=$(echo "${_result}" | jq '.')

    # if we have a result, there was a problem. echo and exit.
    [[ -n "${_result}" ]] && \
        echo error! "${_result}" && \
        echo attempted to send: $(echo "${_sendme}" | jq '.') && \
        exit 1

    exit 0
}

if target=$(build); then send "${target}"; exit 0; else echo "${target}"; exit 1; fi
