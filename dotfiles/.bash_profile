#!/bin/bash

##### This file is for shell agnostic config ##################################

##### Shell Specific logic ####################################################

SHELL_PROG=${0##*/}
if [[ ${SHELL_PROG} = '-bash' || ${SHELL_PROG} == *'bash'* ]]; then
  source ${HOME}/.shellrc_bash
elif [[ ${SHELL_PROG} = '-zsh' || ${SHELL_PROG} == *'zsh'* ]]; then
  source ${HOME}/.shellrc_zsh
else
  echo "Unknown shell rc file!"
  exit 1
fi

##### OS Specific Logic #######################################################

export LSCOLORS='GxFxCxDxBxegedabagaced'
export LS_COLORS='rs=0:di=01;36:ln=01;35:mh=00:pi=40;33:so=01;32:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;31:'

if [[ $(uname) == 'Darwin' ]]; then
  # MacOS
  hostname=$(scutil --get ComputerName)
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
  hostname=$(hostname)
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

###### PATH Manipulation ######################################################

export PATH=/usr/local/bin:$PATH
export PATH="${HOME}/bin:$PATH"

##### Homebrew Setup/Configuration ############################################

export PATH=$PATH:/usr/local/sbin

##### Shell Functions #########################################################

psproc() {
  if [ -n "$1" ]; then
    \ps -e -o pid,etime,command | grep "$1"
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

##### Source other files ######################################################

if [ -d "${HOME}/.shellrc.d" ] && [ -n "$(ls -A "${HOME}/.shellrc.d/")" ]; then
  for f in "${HOME}/.shellrc.d/"*; do
    echo "Sourcing $f"
    source "$f"
  done
fi

echo "Shell initialization complete."

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
