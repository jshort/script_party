#!/usr/bin/env bash

getHelp() {
    echo "usage: ${0##*/} [-h|--help|--dry-run] [dir]" >&2
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


dir=${1:-'.'}
retval=0

if [ -n "$dryRun" ]; then
    while read -r oldname; 
    do 
        newname=$(sed 's/ /_/g' <<< "$oldname")
        if [ -e "$dir/$newname" ]; then
            echo "File $newname already exists, not overwriting..."
            retval=2
        else
            echo "Old name: $oldname, and new name: $newname"
        fi
    done < <(ls -1 "$dir" | grep " ")
else
    while read -r oldname; 
    do 
        newname=$(sed 's/ /_/g' <<< "$oldname")
        if [ -e "$dir/$newname" ]; then
            echo "File $newname already exists, not overwriting..."
            retval=2
        else
            mv "$dir/$oldname" "$dir/$newname"
        fi
    done < <(ls -1 "$dir" | grep " ")
fi

exit $retval











