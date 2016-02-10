#!/bin/bash

###############COLOR CODE STARTS###############

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

###############COLOR CODE ENDS###############

##### Various Aliases ###########################
alias clj='java -cp /Users/jshort/clojure-1.5.1/clojure-1.5.1.jar clojure.main'
alias nailgun='java -cp /Users/jshort/.vim/lib/server-2.3.0.jar:/Users/jshort/clojure-1.5.1/clojure-1.5.1.jar vimclojure.nailgun.NGServer'
#alias webex='cd ~/Library/Application\ Support/WebEx\ Folder/1324; open Meeting\ Center.app/'
alias buildnt='mvn clean install -DskipTests'
alias build='mvn clean install'
alias run='mvn jetty:run'
alias checkstyle='mvn checkstyle:checkstyle'
alias ls='ls -G'
alias jj='java -jar'
alias ssha='eval $(ssh-agent) && ssh-add'
alias cdwp='cd ~/workplace2.0'
alias md5sum='md5 -r'

####### PATH manipulation #####################
export PATH=$PATH:/usr/local/sbin
export PATH=/usr/local/bin:$PATH
export PATH=/Users/jwshort/bin:$PATH
export PATH=/usr/local/Cellar/emacs/24.2/bin:$PATH

####### PS1 Config ############################

export PS1="$BRIGHT_RED(\A) $CYAN\u$NORMAL@$YELLOW$(scutil --get ComputerName) $GREEN\W$BLUE\$(parse_git_branch)$NORMAL > "
export LSCOLORS=GxFxCxDxBxegedabagaced

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

##### Bash Completion #########################
. ~/.bash_completion

##### Source other files ######################
if [ -d "${HOME}/.bash_profile.d" ]; then
    shopt -s nullglob; for f in "${HOME}/.bash_profile.d/"*; do
        echo "Sourcing $f"
        . "$f"
    done
fi

##### Done ####################################
echo ".bash_profile executed"
