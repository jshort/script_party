#!/usr/bin/env bash

# Script to count control-M characters (windows line endings in a directory recursively)
# Arguments:
#   $1 - directory (defaults to '.')
#   $2 - file regex pattern (defaults to .java,.xml,.properties,.sh,.pm,.pl,.MF)

getHelp() {
    echo "usage: $0 [-h|--help] [dir] [fileRegex]" >&2
    exit 1
}

optspec=":h-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                help)
                    getHelp
                    ;;
                *)
                    getHelp
                    ;;
            esac;;
        h)
            getHelp
            ;;
        *)
            getHelp
            ;;
    esac
done

shift $(($OPTIND-1))

dir=${1:-"."}
fileRegex=${2:-'.*\.java\|.*\.xml\|.*\.properties\|.*\.sh\|.*\.pm\|.*\.MF\|.*\.pl'}

egrep -r -l "\x0d$" $dir | grep "${fileRegex}"
