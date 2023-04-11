#!/usr/bin/env bash
#
# Discord.sh - Discord on command-line
# Copyright (C) 2023 ChaoticWeg & fieu

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

# check for curl
curl --version >/dev/null 2>&1
curl_ok=$?

[[ "$curl_ok" -eq 127 ]] && \
    echo "fatal: curl not installed" && exit 2
# curl exists and runs ok

get_ts() { date -u -Iseconds; };

thisdir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
webhook_file="${thisdir}/.webhook"

help_text="Usage: discord.sh --webhook-url=<url> [OPTIONS]

General options:
  --help                         Display this help and exit
  --text <text>                  Body text of message to send
  --tts                          Send message with text-to-speech enabled
  --webhook-url                  Specify the Discord webhook URL
  --dry-run                      Dry run, don't actually send message
  --version                      Print version information

File options:
  --file <file>                  Send file <file>

Identity options:
  --username <name>              Set username to <name>
  --avatar <url>                 Set avatar to image located at <url>
  --modify                       Modify webhook (pass with avatar/username permanantly update webhook)

Embedded content options:
  Main:
    --title <title>              Display embed title as <title>
    --description <description>  Display embed description as <description>
    --url <url>                  URL of content
    --color <color>              Set color of bar on left border of embed
      Syntax of <color>:
        Option 1: 0x<hexadecimal number> (Example: --color 0xFFFFF)
        Option 2: <decimal number> (Example: --color 16777215)
    --thumbnail <url>            Set thumbnail to image located at <url>

  Author:
    --author <name>                Display author name as <name>
    --author-icon <url>            Display author icon as image located at <url>
    --author-url <url>             Set author title to go to <url> when clicked

  Image:
    --image <url>                  Set image to image located at <url>
    --image-height <number>        Set image height to <number> pixels
    --image-width <number>         Set image width to <number> pixels

  Fields:
    --field <name,value,inline>  Add field to embed
        Example: --field \"CPU;95%;false\"
        Example: --field \"Hostname;localhost\"
        Types:
            name: string
            value: string
            inline: boolean (default: true) (optional)

  Footer:
    --footer <text>                Display <text> in footer
    --footer-icon <url>            Display image located at <url> in footer
    --timestamp                    Display timestamp"

# HELP TEXT PLEASE
[[ "$#" -eq 0 ]] && echo "$help_text" && exit 0
[[ "${1}" == "help" ]] && echo "$help_text" && exit 0

##
# add field to stack
##
add_field() {
    local _name
    local _value
    local _inline
    fields="${fields:=}"

    # don't add if not embedding
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    _name="$(echo "$1" | cut -d';' -f1)"
    _value="$(echo "$1" | cut -d';' -f2)"
    _inline="$(echo "$1" | cut -d';' -f3)"
    _inline="${_inline:-true}"

    fields="${fields}{\"name\": \"${_name}\", \"value\": \"${_value}\", \"inline\": ${_inline}},"
}

build_fields() {
    echo ", \"fields\": [${fields::-1} ]"
}

print_version() {
    echo "discord.sh version v2.0.0-dev"
    exit 0
}

# gather arguments
while (( "$#" )); do
    case "${1}"  in
	--help) echo "$help_text" && exit 0;;
	-h) echo "$help_text" && exit 0;;

        --dry-run) is_dry=1; shift;;
        --tts) is_tts=1; shift;;
        --version) print_version;;

        --webhook-url=*) webhook_url=${1/--webhook-url=/''}; shift;;
        --webhook-url*) webhook_url=${2}; shift; shift;;

        --modify*) modify=1; shift;;

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

        # fields
        --field=*) add_field "${1/--field=/''}"; embedding=1; shift;;
        --field*) add_field "${2}"; embedding=1; shift; shift;;

        # footer
        --footer-icon=*) embed_footericon=${1/--footer-icon=/''}; embedding=1; shift;;
        --footer-icon*) embed_footericon=${2}; embedding=1; shift; shift;;

        --footer=*) embed_footertext=${1/--footer=/''}; embedding=1; shift;;
        --footer*) embed_footertext=${2}; embedding=1; shift; shift;;

        # file
        --file=*) file_path=${1/--file=/''}; has_file=1; shift;;
        --file*) file_path=${2}; has_file=1; shift; shift;;

        # unknown argument. bail out

        *) echo "fatal: unknown argument '${1}'"; exit 1;;

    esac
done

# files must be standalone
[[ -n "${embedding}" ]] && [[ -n "${has_file}" ]] && \
    echo "fatal: files must be sent on their own without embeds (i.e. flags such as description, color, footer, etc.)" && \
    exit 3

# set webhook url (if none exists after argument handling)
[[ -z ${webhook_url} ]] && [[ -n "${DISCORD_WEBHOOK}" ]] && webhook_url=${DISCORD_WEBHOOK}
[[ -z ${webhook_url} ]] && [[ -r "${webhook_file}" ]] && [[ -f "${webhook_file}" ]] && webhook_url=$(cat "${webhook_file}")

# no webhook could be found. bail out
[[ -z ${webhook_url} ]] && echo "fatal: no --webhook-url passed or no .webhook file to read from" && exit 1;


enforce_limits() {
    # title <= 256
    [[ -n "${embed_title}" ]] && [[ "${#embed_title}" -gt 256 ]] && \
        embed_title="${embed_title::256}" && \
        echo "warning: embed title limited to ${#embed_title} characters"

    # description <= 2048
    [[ -n "${embed_description}" ]] && [[ "${#embed_description}" -gt 2048 ]] && \
        embed_description="${embed_description::2048}" && \
        echo "warning: embed description limited to ${#embed_description} characters"

    # footer.text <= 2048
    [[ -n "${embed_footertext}" ]] && [[ "${#embed_footertext}" -gt 2048 ]] && \
        embed_footertext="${embed_footertext::2048}" && \
        echo "warning: embed footer text limited to ${#embed_footertext} characters"

    # author.name <= 256
    [[ -n "${embed_authorname}" ]] && [[ "${#embed_authorname}" -gt 256 ]] && \
        embed_authorname="${embed_authorname::256}" && \
        echo "warning: embed author name limited to ${#embed_authorname} characters"
}

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
    local _ts
    local _author
    local _thumb
    local _image
    local _footer
    local _fields

    # should we embed? if not, bail out without error
    [[ -z "${embedding}" ]] && exit;
    [[ "${embedding}" -ne 1 ]] && exit;

    [[ -n "${embed_title}" ]] && local _title=", \"title\": \"${embed_title}\""
    [[ -n "${embed_description}" ]] && local _desc=", \"description\": \"${embed_description}\""
    [[ -n "${embed_url}" ]] && local _eurl=", \"url\": \"${embed_url}\""
    [[ -n "${embed_color}" ]] && local _color=", \"color\": ${embed_color}"
    [[ -n "${embed_timestamp}" ]] && [[ "${embed_timestamp}" -eq 1 ]] && _ts=", \"timestamp\": \"$(get_ts)\""

    _author="$(build_author)"
    _thumb="$(build_thumbnail)"
    _image="$(build_image)"
    _fields="$(build_fields)"
    _footer="$(build_footer)"

    echo ", \"embeds\": [{ \"_\": \"_\"${_title}${_desc}${_eurl}${_color}${_ts}${_author}${_thumb}${_image}${_fields}${_footer} }]"
}

convert_image_url_to_base64() {
    local _image
    local _image_type
    local _image_base64

    # save image to temp file
    _image="$(mktemp)"
    curl -s "${1}" > "${_image}"

    # get image type
    _image_type="$(file -b --mime-type "${_image}")"

    # convert to base64
    _image_base64=$(<"$_image" base64)

    # remove temp file
    rm "${_image}"

    # output
    echo "data:${_image_type};base64,${_image_base64}"
}


build() {
    local _content
    local _username
    local _avatar
    local _embed

    # need to have SOMETHING to build
    [[ -z "${has_file}" ]] && \
        [[ -z "${text}" ]] && \
        [[ -z "${embed_title}" ]] && \
        [[ -z "${embed_description}" ]] && \
        [[ -z "${embed_imageurl}" ]] && \
        [[ -z "${modify}" ]] && \
        [[ -z "${username}" ]] && \
        [[ -z "${avatar_url}" ]] && \
            echo "fatal: nothing to build" && exit 1
    
    # if only specified modify but not username/avatar, exit with error
    [[ -n "${modify}" ]] && \
        [[ -z "${username}" ]] && \
        [[ -z "${avatar_url}" ]] && \
            echo "fatal: must pass --username or --avatar with --modify" && exit 1
    # strip 0x prefix and convert hex to dec if necessary
    [[ -n "${embed_color}" ]] && [[ "${embed_color}" =~ ^0x[0-9a-fA-F]+$ ]] && embed_color="$(( embed_color ))"

    # embed color must be an integer, if given
    [[ -n "${embed_color}" ]] && ! [[ "${embed_color}" =~ ^[0-9]+$ ]] && \
        echo "fatal: illegal color '${embed_color}'" && exit 1

    # let's build, boys
    [[ -n "${is_tts}" ]] && _tts=", \"tts\": true"
    [[ -n "${text}" ]] && _content=", \"content\": \"${text}\""
    # if we're modifying, change the username field to name
    [[ -n "${username}" ]] && [[ -n "${modify}" ]] && _username=", \"name\": \"${username}\""
    [[ -n "${username}" ]] && [[ -z "${modify}" ]] && _username=", \"username\": \"${username}\""
    # if avatar_url is set and modify is set, change the avatar_url field to avatar and convert to base64
    # if avatar_url is set and modify is not set, change the avatar_url field to avatar
    [[ -n "${avatar_url}" ]] && [[ -n "${modify}" ]] && _avatar=", \"avatar\": \"$(convert_image_url_to_base64 "${avatar_url}")\""
    [[ -n "${avatar_url}" ]] && [[ -z "${modify}" ]] && _avatar=", \"avatar_url\": \"${avatar_url}\""

    [[ -n "${embedding}" ]] && _embed="$(build_embed)"

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

    # If any arguments except for username, modify and avatar are specified (modify option required), then exit with an error
    if [[ -n "${username}" ]] || [[ -n "${avatar_url}" ]] && [[ "${modify}" = 1 ]]; then
        if [[ -n "${text}" ]] && [[ -n "${embed_title}" ]] && [[ -n "${embed_description}" ]] && [[ -n "${embed_url}" ]] && [[ -n "${embed_color}" ]] && [[ -n "${embed_timestamp}" ]] && [[ -n "${embed_authorurl}" ]] && [[ -n "${embed_authoricon}" ]] && [[ -n "${embed_authorname}" ]] && [[ -n "${embed_thumbnail}" ]] && [[ -n "${embed_imageheight}" ]] && [[ -n "${embed_imagewidth}" ]] && [[ -n "${embed_imageurl}" ]] && [[ -n "${embed_footertext}" ]] && [[ -n "${embed_footericon}" ]] && [[ -n "${fields}" ]] && [[ -n "${file_path}" ]]; then
            echo "fatal: no arguments specified (except for username, modify and avatar)"; exit 1;
        fi
        _result=$(curl -H "Content-Type: application/json" -H "Expect: application/json" -X PATCH "${webhook_url}" -d "${_sendme}" 2>/dev/null)
        send_ok=$?
        [[ "${send_ok}" -ne 0 ]] && echo "fatal: curl failed with code ${send_ok}" && exit $send_ok
        exit 0;
    fi

    # make the POST request and parse the results
    # results should be empty if there's no problem. otherwise, there should be code and message
    local _result

     _result=$(curl -H "Content-Type: application/json" -H "Expect: application/json" -X POST "${webhook_url}" -d "${_sendme}" 2>/dev/null)
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

##
# send a file to the channel
##
send_file() {
    # gotta have a file
    [[ ( -z "${has_file}" ) || ( -z "${file_path}" ) ]] && echo "fatal: give me a file" && exit 4

    local _json
    if ! _json=$(build); then echo "${_json}"; exit 1; fi

    # dry run
    if [[ ( -n "${is_dry}" ) && ( "${is_dry}" -ne 0 ) ]]; then
        echo "${_json}" | jq '.'
        echo "file=${file_path}"
        exit 0
    fi

    [[ -n "${is_dry}" ]] && [[ "${is_dry}" -ne 0 ]] && \
        echo "${_json}" && exit 0

    # send with correct Content-Type and url-encoded data
    curl -i \
        -H "Expect: application/json" \
        -F "file=@${file_path}" \
        -F "payload_json=${_json}" \
        "${webhook_url}" >/dev/null 2>&1

    # error checking 

    sent_ok=$?
    [[ "${sent_ok}" -eq 0 ]] && exit 0

    echo "fatal: curl exited with code ${sent_ok} when sending file \"${file_path}\""
}


## enforce discord API limits
enforce_limits

## no file? build and send normally
if ! [[ "${has_file}" -eq 1 ]]; then
    if target=$(build); then
        send "${target}"
    else
        echo "${target}"
        exit 1
    fi
fi


## has file. send as such
send_file
