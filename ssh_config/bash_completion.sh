#!/bin/bash

_ssh() {
  local cur config_hosts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  config_hosts=$(ssh-config | tail -n+3 | cut -f 1 -d " ")

  if [[ ! ${cur} == -* ]] ; then
    COMPREPLY=( $(compgen -W "${config_hosts}" -- ${cur}) )
    return 0
  fi
}

complete -F _ssh ssh
