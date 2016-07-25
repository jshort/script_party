#!/bin/bash

##### Color Codes #############################################################

DULL=0
BRIGHT=1

FG_BLACK=30; FG_RED=31; FG_GREEN=32; FG_YELLOW=33; FG_BLUE=34
FG_VIOLET=35; FG_CYAN=36; FG_WHITE=37

FG_NULL=00

BG_BLACK=40; BG_RED=41; BG_GREEN=42; BG_YELLOW=43; BG_BLUE=44
BG_VIOLET=45; BG_CYAN=46; BG_WHITE=47

BG_NULL=00

##
# ANSI Escape Commands
##
ESC="\033"
NORMAL="\[$ESC[m\]"
RESET="\[$ESC[${DULL};${FG_WHITE};${BG_NULL}m\]"

##
# Shortcuts for Colored Text ( Bright and FG Only )
##

# DULL TEXT
BLACK="\[$ESC[${DULL};${FG_BLACK}m\]"
RED="\[$ESC[${DULL};${FG_RED}m\]"
GREEN="\[$ESC[${DULL};${FG_GREEN}m\]"
YELLOW="\[$ESC[${DULL};${FG_YELLOW}m\]"
BLUE="\[$ESC[${DULL};${FG_BLUE}m\]"
VIOLET="\[$ESC[${DULL};${FG_VIOLET}m\]"
CYAN="\[$ESC[${DULL};${FG_CYAN}m\]"
WHITE="\[$ESC[${DULL};${FG_WHITE}m\]"

# BRIGHT TEXT
BRIGHT_BLACK="\[$ESC[${BRIGHT};${FG_BLACK}m\]"
BRIGHT_RED="\[$ESC[${BRIGHT};${FG_RED}m\]"
BRIGHT_GREEN="\[$ESC[${BRIGHT};${FG_GREEN}m\]"
BRIGHT_YELLOW="\[$ESC[${BRIGHT};${FG_YELLOW}m\]"
BRIGHT_BLUE="\[$ESC[${BRIGHT};${FG_BLUE}m\]"
BRIGHT_VIOLET="\[$ESC[${BRIGHT};${FG_VIOLET}m\]"
BRIGHT_CYAN="\[$ESC[${BRIGHT};${FG_CYAN}m\]"
BRIGHT_WHITE="\[$ESC[${BRIGHT};${FG_WHITE}m\]"

# REV TEXT as an example
REV_CYAN="\[$ESC[${DULL};${BG_WHITE};${BG_CYAN}m\]"
REV_RED="\[$ESC[${DULL};${FG_YELLOW}; ${BG_RED}m\]"

##### General Aliases #########################################################

alias start_mongo='mongod --dbpath ~/mongodb/data/db'

# clojure
alias clj='java -cp /Users/jshort/clojure-1.5.1/clojure-1.5.1.jar clojure.main'
alias nailgun='java -cp /Users/jshort/.vim/lib/server-2.3.0.jar:/Users/jshort/clojure-1.5.1/clojure-1.5.1.jar vimclojure.nailgun.NGServer'

# maven
alias buildnt='mvn clean install -DskipTests'
alias mci='mvn clean install'
alias mc='mvn clean'
alias mrun='mvn jettyd:run'
alias checkstyle='mvn checkstyle:checkstyle'

# generic
alias ..='cd ..'
alias ll='ls -la'
alias l.='ls -d .* -G'
alias ls='ls -G'
alias jj='java -jar'
alias ssha='eval $(ssh-agent) && ssh-add'
alias cdwp='cd ~/workplace2.0'
alias md5sum='md5 -r'
alias sha1='openssl sha1'

alias viewimage='open -a Preview'

alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'
alias ports='netstat -tulanp'

## pass options to free ##
alias meminfo='free -m -l -t'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

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

alias netstat-tunlp='sudo lsof -i -n -P | grep TCP'

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
export PATH=/usr/local/Cellar/emacs/24.2/bin:$PATH

##### Homebrew Setup/Configuration ############################################

export PATH=$PATH:/usr/local/sbin

##### Terminal Aesthetics Configuration #######################################

export LSCOLORS=GxFxCxDxBxegedabagaced

##### PS1 Prompt Configuration ################################################

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

export PS1="$BRIGHT_RED(\A) $CYAN\u$NORMAL@$YELLOW$(scutil --get ComputerName) $GREEN\W$BLUE\$(parse_git_branch)$NORMAL > "

##### Autocompletion Configuration ############################################

. ~/.bash_completion

##### Source other files ######################################################

if [ -d "${HOME}/.bash_profile.d" ]; then
    shopt -s nullglob; for f in "${HOME}/.bash_profile.d/"*; do
        echo "Sourcing $f"
        . "$f"
    done
fi

##### Setup Speedtest Tool ####################################################

if [ ! -e "${HOME}/bin/speedtest-cli" ]; then
    curl -sLo ${HOME}/bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest_cli.py
    chmod +x ${HOME}/bin/speedtest-cli
fi

##### Done ####################################################################
echo ".bash_profile executed"