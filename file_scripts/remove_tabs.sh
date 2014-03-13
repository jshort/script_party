#!/usr/bin/env bash

getHelp() {
    echo "usage: ${0##*/} [-h|--help|--dry-run] [fileRegex]" >&2
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
                dry-run)
                    dryRun=true
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

fileRegex=${1:-".*\.java"}

if [ -n "$dryRun" ]; then
    for i in $(egrep -r -l "\x09" . | grep "$fileRegex"); do echo "$i"; done

else
    for i in $(egrep -r -l "\x09" . | grep "$fileRegex"); do expand -t 7 "$i" > /tmp/e && mv /tmp/e "$i"; done
fi
