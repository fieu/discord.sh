#!/usr/bin/env bash
#
# Discord.sh - Discord on command-line
# by ChaoticWeg and Suce

shopt -s lastpipe   # avoid subshell weirdness hopefully
shopt -so pipefail  # hopefully correctly get $? in substitution

# check for jq

jq --version >/dev/null 2>&1
jq_ok=$?

[[ "$jq_ok" -eq 127 ]] && \
    echo "fatal: jq not installed" && exit 2
[[ "$jq_ok" -ne 0 ]] && \
    echo "fatal: unknown error in jq" && exit 2

# jq exists and runs ok

get_ts() { echo "$(date -u --iso-8601=seconds)"; };

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

        --avatar=*) avatar_url=${1/--avatar=/''}; shift;;
        --avatar*) avatar_url=${2}; shift; shift;;

        --text=*) text=${1/--text=/''}; shift;;
        --text*) text=${2}; shift; shift;;

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

        --author-url=*) embed_authorurl=${1/--author-url=/''}; embedding=1; shift;;
        --author-url*) embed_authorurl=${2}; embedding=1; shift; shift;;

        --author-icon=*) embed_authoricon=${1/--author-icon=/''}; embedding=1; shift;;
        --author-icon*) embed_authoricon=${2}; embedding=1; shift; shift;;

        --author=*) embed_authorname=${1/--author=/''}; embedding=1; shift;;
        --author*) embed_authorname=${2}; embedding=1; shift; shift;;

        # thumbnail

        --thumbnail=*) embed_thumbnail=${1/--thumbnail=/''}; embedding=1; shift;;
        --thumbnail*) embed_thumbnail=${2}; embedding=1; shift; shift;;

        # image

        --image-height=*) embed_imageheight=${1/--image-height=/''}; embedding=1; shift;;
        --image-height*) embed_imageheight=${2}; embedding=1; shift; shift;;

        --image-width=*) embed_imagewidth=${1/--image-width=/''}; embedding=1; shift;;
        --image-width*) embed_imagewidth=${2}; embedding=1; shift; shift;;

        --image=*) embed_imageurl=${1/--image=/''}; embedding=1; shift;;
        --image*) embed_imageurl=${2}; embedding=1; shift; shift;;

        # footer

        --footer-icon=*) embed_footericon=${1/--footer-icon=/''}; embedding=1; shift;;
        --footer-icon*) embed_footericon=${2}; embedding=1; shift; shift;;

        --footer=*) embed_footertext=${1/--footer=/''}; embedding=1; shift;;
        --footer*) embed_footertext=${2}; embedding=1; shift; shift;;

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

    echo ", \"author\": { \"_\": \"_\"${_name}${_url}${_icon} }"
}


##
# build thumbnail object
##
build_thumbnail() {
    # don't build if not embedding
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    [[ -n "${embed_thumbnail}" ]] && local _url="\"url\": \"${embed_thumbnail}\""

    echo ", \"thumbnail\": { ${_url} }"
}


##
# build footer object
##
build_footer() {
    # don't build if not embedding
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    [[ -n "${embed_footertext}" ]] && local _text=", \"text\": \"${embed_footertext}\""
    [[ -n "${embed_footericon}" ]] && local _icon=", \"icon_url\": \"${embed_footericon}\""

    echo ", \"footer\": { \"_\":\"_\"${_text}${_icon} }"
}


##
# build image object
##
build_image() {
    # don't build if not embedding
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    [[ -n "${embed_imageurl}" ]] && local _iurl=", \"url\": \"${embed_imageurl}\""
    [[ -n "${embed_imageheight}" ]] && local _height=", \"height\": ${embed_imageheight}"
    [[ -n "${embed_imagewidth}" ]] && local _width=", \"width\": ${embed_imagewidth}"

    echo ", \"image\": { \"_\": \"_\"${_iurl}${_height}${_width} }"
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
    [[ -n "${embed_url}" ]] && local _eurl=", \"url\": \"${embed_url}\""
    [[ -n "${embed_color}" ]] && local _color=", \"color\": ${embed_color}"
    [[ -n "${embed_timestamp}" ]] && [[ "${embed_timestamp}" -eq 1 ]] && local _ts=", \"timestamp\": \"$(get_ts)\""

    local _author="$(build_author)"
    local _thumb="$(build_thumbnail)"
    local _image="$(build_image)"
    local _footer="$(build_footer)"

    echo ", \"embeds\": [{ \"_\": \"_\"${_title}${_desc}${_eurl}${_color}${_ts}${_author}${_thumb}${_image}${_footer} }]"
}


build() {

    # need to have SOMETHING to build
    [[ -z "${text}" ]] && \
        [[ -z "${embed_title}" ]] && \
        [[ -z "${embed_description}" ]] && \
        [[ -z "${embed_imageurl}" ]] && \
            echo "fatal: nothing to build" && exit 1

    # strip 0x prefix and convert hex to dec if necessary
    [[ -n "${embed_color}" ]] && [[ "${embed_color}" =~ ^0x[0-9a-fA-F]+$ ]] && embed_color="$(( $embed_color ))"

    # embed color must be an integer, if given
    [[ -n "${embed_color}" ]] && ! [[ "${embed_color}" =~ ^[0-9]+$ ]] && \
        echo "fatal: illegal color '${embed_color}'" && exit 1

    # let's build, boys

    [[ -n "${is_tts}" ]] && local _tts=", \"tts\": true"
    [[ -n "${text}" ]] && local _content=", \"content\": \"${text}\""
    [[ -n "${username}" ]] && local _username=", \"username\": \"${username}\""
    [[ -n "${avatar_url}" ]] && local _avatar=", \"avatar_url\": \"${avatar_url}\""
    [[ -n "${embedding}" ]] && local _embed="$(build_embed)"

    local _prefix="\"wait\": true${_tts}${_content}${_username}${_avatar}${_embed}"

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
        echo attempted to send: "$(echo "${_sendme}" | jq '.')" && \
        exit 1

    exit 0
}

if target=$(build); then send "${target}"; exit 0; else echo "${target}"; exit 1; fi
