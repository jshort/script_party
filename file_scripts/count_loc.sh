#!/usr/bin/env bash

get_help() {
  echo "usage: $0 [-h|--help] [dir] [fileExtension]" >&2
  exit 1
}

optspec=":h-:"
while getopts "$optspec" optchar; do
  case "${optchar}" in
    -)
      case "${OPTARG}" in
        help)
          get_help
          ;;
        *)
          get_help
          ;;
      esac
      ;;
    h)
      get_help
      ;;
    *)
      get_help
      ;;
  esac
done

shift $(($OPTIND-1))

dir=${1:-"."}
fileExtension=${2:-"*.java"}

for i in $(find "$dir" -name "$fileExtension"); do cat $i; done | grep -v '^\s*$' | wc -l
