#!/bin/bash

##### Notes #####
# Map at the system level Caps Lock to Control
# Powerline/iTerm2 setup: https://coderwall.com/p/yiot4q/setup-vim-powerline-and-iterm2-on-mac-os-x
# Fonts: git clone https://github.com/powerline/fonts.git && cd fonts && ./install.sh
# Set iTerm2 font (non-ASCII too) to be: Inconsolata for powerline 14pt
# pyenv setup:
#   curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
#   or with package manager (yum, dnf, brew)
#
#   pyenv install 2.7.15
#   PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.6.5
#
#   pyenv virtualenv 2.7.15 nvim2
#   pyenv virtualenv 3.6.5 nvim3
#
#   pyenv activate nvim2
#   pip install neovim
#   pip install pynvim
#   pyenv which python  # Note the path
#
#   pyenv activate nvim3
#   pip install neovim
#   pip install pynvim
#   pyenv which python  # Note the path
#
# YCM:
#   cd to YCM dir:
#   ./install.py --clang-completer --go-completer --java-completer
#   or for linux:
#   ./install.py --go-completer --java-completer

DIR=$(cd $(/usr/bin/dirname $0) 2>/dev/null && pwd)

DOTFILES=(
  .bash_completion
  .bash_profile
  .config/nvim/init.vim
  .gitconfig
  .gitignore
  .motd
  .shellrc-bash
  .shellrc-zsh
  .shellrc.d/01-setup
  .shellrc.d/diff-so-fancy
  .shellrc.d/oh-my-zsh
  .shellrc.d/pyenv
  .shellrc.d/rbenv
  .shellrc.d/speedtest-cli
  .shellrc.d/ssh-agent-config
  .shellrc.d/vim
  .shellrc.d/zzz-setup
  .vim/fzfcmd
  .vimrc
  .zshrc
)

FILE_SCRIPTS=(
  count-ctl-m.sh
  count-loc.sh
  remove-tabs.sh
  replace-space-underscore.sh
  find-in-jar
)

GIT_SCRIPTS=(
  git-changed
  git-files-changed
  git-rec
)

VAGRANT_SCRIPTS=(
  vagrantplus
)

SSH_SCRIPTS=(
  ssh-config
)

OTHER_SCRIPTS=(
  screen-grep
  fullload
)

BREW=(
  brewdeps
)

indent() {
  local string="${1}"
  local num_spaces="${2}"

  while read -r line; do
    printf "%${num_spaces}s%s\n" '' "${line}"
  done <<< "${string}"
}

cleanup_dir() {
  dir="$1"
  rm -rf "${dir}"
}

setup_powerline_fonts() {
  indent 'Installing powerline fonts.' 0
  tmp_dir=$(mktemp -d /tmp/env-setup.XXXXXX)
  pushd $tmp_dir > /dev/null
  indent "$(git clone -q https://github.com/powerline/fonts.git && cd fonts && ./install.sh)" 4
  popd > /dev/null
  trap "cleanup_dir ${tmp_dir}" EXIT
}

symlink_dir() {
  local dir_prefix=$1
  local target_dir=$2
  local file=$3

  target="$target_dir/$file"
  if [ ! -d "$(/usr/bin/dirname $target)" ]; then
    indent "Base dir for $target does not exist, creating it..." 4
    mkdir -p $(/usr/bin/dirname $target)
  fi

  if [ -L "$target" ]; then
    indent "$target is already symlinked." 4
  elif [ -e "$target" ]; then
    indent "$target is already a file." 4
  else
    indent "Symlinking $target." 4
    ln -s "$dir_prefix/$file" "$target"
  fi
}

symlink_dirs() {
  local dir_prefix=$1
  local target_dir=$2
  local file_arr=("${!3}")

  for i in "${file_arr[@]}"; do
    symlink_dir "${dir_prefix}" "${target_dir}" ${i}
  done
}

main() {
  ##### Setup VIM ####
  mkdir -p "${HOME}/.vim/tmp"

  # Vim Plug Setup
  mkdir -p "${HOME}/.vim/plugged"
  mkdir -p "${HOME}/.vim/autoload"
  mkdir -p "${HOME}/.local/share/nvim/site"
  if [ ! -L "${HOME}/.local/share/nvim/plugged" ]; then
    ln -s "${HOME}/.vim/plugged" "${HOME}/.local/share/nvim/plugged"
  fi
  if [ ! -L "${HOME}/.local/share/nvim/site/autoload" ]; then
    ln -s "${HOME}/.vim/autoload" "${HOME}/.local/share/nvim/site/autoload"
  fi
  curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Powerline fonts
  if [ "$1" != "--no-fonts" ]; then
    indent "Setting up Powerline fonts:" 0
    setup_powerline_fonts
  fi

  cd ${DIR}

  #### Setup Script/RC symlinks ####
  indent "Symlinking scripts and dotfiles:" 0
  mkdir -p $HOME/bin
  symlink_dirs "$DIR/dotfiles" $HOME DOTFILES[@]
  symlink_dirs "$DIR/file_scripts" "$HOME/bin" FILE_SCRIPTS[@]
  symlink_dirs "$DIR/ssh_config" "$HOME/bin" SSH_SCRIPTS[@]
  symlink_dirs "$DIR/git" "$HOME/bin" GIT_SCRIPTS[@]
  symlink_dirs "$DIR/vagrant_mgmt" "$HOME/bin" VAGRANT_SCRIPTS[@]
  symlink_dirs "$DIR/other_scripts" "$HOME/bin" OTHER_SCRIPTS[@]
  symlink_dirs "$DIR/brew" "$HOME/bin" BREW[@]

  #### Extra Setup ####
  indent "Running extra setup if available:" 0
  if [ -f ~/.env-setup-extra ]; then
    indent "Found ~/.env-setup-extra:" 4
    bash ~/.env-setup-extra
  fi

  indent "Setup Complete" 0
  exit 0
}

main "$@"
