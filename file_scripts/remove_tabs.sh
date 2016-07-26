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

if grep --version | grep "GNU" > /dev/null; then
  cmdString=(grep -P)
else
  cmdString=(egrep)
fi

arr=$("${cmdString[@]}" -r -l "\x09" . | grep "${fileRegex}")

if [ -n "$dryRun" ]; then
  for i in $arr; do echo "$i"; done
else
  for i in $arr; do expand -t 7 "$i" > /tmp/e && mv /tmp/e "$i"; done
fi
