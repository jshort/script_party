#!/bin/bash

##### This file is for shell agnostic config ##################################

##### Shell Specific logic ####################################################

SHELL_PROG=${0##*/}
if [[ ${SHELL_PROG} = '-bash' || ${SHELL_PROG} == *'bash'* ]]; then
  source ${HOME}/.shellrc-bash
  [ -f ${HOME}/.shellrc-bash-extra ] && source ${HOME}/.shellrc-bash-extra
  [ -f ${HOME}/.fzf.bash ] && source ${HOME}/.fzf.bash
elif [[ ${SHELL_PROG} = '-zsh' || ${SHELL_PROG} == *'zsh'* ]]; then
  source ${HOME}/.shellrc-zsh
  [ -f ${HOME}/.shellrc-zsh-extra ] && source ${HOME}/.shellrc-zsh-extra
  [ -f ${HOME}/.fzf.zsh ] && source ${HOME}/.fzf.zsh
else
  echo 'Unknown shell rc file!'
  exit 1
fi

##### OS Specific Logic #######################################################

export LSCOLORS='GxFxCxDxBxegedabagaced'
export LS_COLORS='rs=0:di=01;36:ln=01;35:mh=00:pi=40;33:so=01;32:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;31:'

if [[ $(uname) == 'Darwin' ]]; then
  # MacOS
  alias ls='ls -GpF'
  [ -e /usr/local/bin/gls ] && alias ls='gls --color -F'
  alias ps='ps -ej'
  alias psuptime='ps -ax -o etime,command -c'
  if [ -e '/usr/local/bin/gsed' ]; then
    alias sed='/usr/local/bin/gsed'
  fi
  if [ -e '/usr/local/bin/gdate' ]; then
    alias date='/usr/local/bin/gdate'
  fi
  alias ldd='otool -L'
  alias md5sum='md5 -r'
  alias netstat-tunlp='sudo lsof -i -n -P | grep TCP'
  alias viewimage='open -a Preview'
else
  # Linux
  alias ls='ls -pF --color=auto'
  alias ps='ps -ef'
fi

##### General Aliases #########################################################

alias start_mongo='mongod --dbpath ~/mongodb/data/db'

# hex dump utility
alias od='od -c -t x1'

# maven
alias buildnt='mvn clean install -DskipTests'
alias mci='mvn clean install'
alias mc='mvn clean'
alias mh='mvn help:describe -Ddetail' # then pass -Dcmd= or -Dplugin=<group>:<artifact>
alias mrun='mvn jetty:run'
alias checkstyle='mvn checkstyle:checkstyle'

# docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dip='docker image prune'
alias drm='docker rm'
alias drmi='docker rmi'

dsrm() {
  if [ -z "${1}" ]; then
    echo "Please supply docker container id or name." >&2
    return 1
  fi
  for i in "${@}"; do
    docker stop "${i}" && docker rm "${i}"
  done
}

# generic
alias ..='cd ..'
alias ll='ls -la'
alias l.='ls -d .*'
alias jj='java -jar'
alias ssha='eval $(ssh-agent) && ssh-add'
alias cdwp='cd ~/workplace'
alias sha1='openssl sha1'

alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'

## pass options to free ##
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='\ps -e -o pid,%cpu,%mem,command | tail -n +2 | sort -nr -k 3 | head -10'
alias psmemall='\ps -e -o pid,rss,vsz,command | grep'

## get top process eating cpu ##
alias pscpu='\ps -e -o pid,%cpu,%mem,command | tail -n +2 | sort -nr -k 2 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

##### Vagrant Aliases #########################################################

alias vst='vagrant status'
alias vup='vagrant up'
alias vssh='vagrant ssh'

##### Go Aliases ##############################################################

alias grun='go run'
alias ginst='go install'

##### Curl Aliases ############################################################

alias curlkv='curl -k -v'

##### Shell Functions #########################################################

psproc() {
  if [ -n "${1}" ]; then
    \ps -e -o pid,etime,command | grep "${1}"
  else
    \ps -e -o pid,etime,command
  fi
}

msecs() {
  echo $(($(nsecs)/1000000))
}

nsecs() {
  python -c 'import time; print(int(time.time()*1000*1000*1000))'
  # Below doens't work with BSD date and doesn't seem to have full granularity
  # on MacOS, even with GNU date.
  # echo $(date +%s%N)
}

# prints time since the input epoch time in seconds
time_since() {
  local _secs="${1}"
  if [ -z "${_secs}" ]; then
    echo 'Please pass a time in seconds from which to measure.'
    return 1
  fi
  local _delta=$(( $(date +%s) - ${_secs} ))
  # echo "Delta in secs: ${_delta}"
  if (( ${_delta} < 60 )); then
    echo "${_delta}s"
  elif (( ${_delta}/60 < 60 )); then
    echo "$((${_delta}/60))m$((${_delta}%60))s"
  elif (( ${_delta}/3600 < 24 )); then
    echo "$((${_delta}/3600))h$(((${_delta}/60)%60))m$((${_delta}%60))s"
  elif (( ${_delta}/3600/24 < 365 )); then
    echo "$((${_delta}/3600/24))d$(((${_delta}/3600)%24))h$(((${_delta}/60)%60))m$((${_delta}%60))s"
  fi
}

##### Source other files ######################################################

if [ -d "${HOME}/.shellrc.d" ] && [ -n "$(ls -A "${HOME}/.shellrc.d/")" ]; then
  for f in "${HOME}/.shellrc.d/"*; do
    echo "Sourcing $f"
    source "$f"
  done
fi

echo "Shell initialization complete."

#CHEF.NO.SOURCE
