#!/bin/bash

##### Notes #####
# Map at the system level Caps Lock to Control
# Powerline/iTerm2 setup: https://coderwall.com/p/yiot4q/setup-vim-powerline-and-iterm2-on-mac-os-x
# Fonts: git clone https://github.com/powerline/fonts.git && cd fonts && ./install.sh
# Set iTerm2 font (non-ASCII too) to be: Inconsolata for powerline 14pt

DIR=$(cd $(/usr/bin/dirname $0) 2>/dev/null && pwd)

DOTFILES=(
  .bash_completion
  .bash_profile
  .config/nvim/init.vim
  .gitconfig
  .gitignore
  .shellrc.d/oh-my-zsh
  .shellrc.d/rbenv
  .shellrc.d/speedtest-cli
  .shellrc.d/ssh-agent-config
  .shellrc.d/vim
  .shellrc_bash
  .shellrc_zsh
  .vim/fzfcmd
  .vimrc
  .zshrc
)

FILE_SCRIPTS=(
  count_ctl_m.sh
  count_loc.sh
  remove_tabs.sh
  replace_space_underscore.sh
  find_in_jar
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
  screen_grep
  fullload
)

BREW=(
  brewdeps
)

indent() {
    local string="$1"
    local num_spaces="$2"

    while read -r line; do
      printf "%${num_spaces}s%s\n" '' "$line"
    done <<< "$string"
}

cleanup_dir() {
  dir="$1"
  rm -rf "$dir"
}

setup_powerline_fonts() {
  tmp_dir=$(mktemp -d /tmp/env_setup.XXXXXX)
  pushd $tmp_dir > /dev/null
  indent "$(git clone -q https://github.com/powerline/fonts.git && cd fonts && ./install.sh)" 4
  popd > /dev/null
  trap "cleanup_dir ${tmp_dir}" EXIT
}

setup_vim_plugin() {
  plugin_git_url=$1
  plugin_name="$(basename $plugin_git_url .git)"
  if [ ! -d "$plugin_name" ]; then
    indent "Setting up plugin: $plugin_name" 4
    indent "$(git clone $plugin_git_url 2>&1)" 8
  else
    indent "Plugin $plugin_name already exists, updating..." 4
    pushd $plugin_name > /dev/null
    indent "$(git pull)" 8
    popd > /dev/null
  fi
}

symlink_dirs() {
  dir_prefix=$1
  target_dir=$2
  file_arr=("${!3}")

  for i in "${file_arr[@]}"; do
    target="$target_dir/$i"
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
      ln -s "$dir_prefix/$i" "$target"
    fi
  done
}

main() {
  ##### Setup VIM ####
  mkdir -p ${HOME}/.vim/tmp
  mkdir -p ${HOME}/.vim/pack/dist/start

  # Powerline fonts
  if [ "$1" != "--no-fonts" ]; then
    indent "Setting up Powerline fonts:" 0
    setup_powerline_fonts
  fi

  # Plugins
  indent "Setting up VIM plugins:" 0
  cd ${HOME}/.vim/pack/dist/start
  setup_vim_plugin https://github.com/Raimondi/delimitMate.git
  setup_vim_plugin https://github.com/bronson/vim-visual-star-search.git
  setup_vim_plugin https://github.com/fatih/vim-go.git
  setup_vim_plugin https://github.com/junegunn/fzf.git
  setup_vim_plugin https://github.com/skywind3000/asyncrun.vim.git
  setup_vim_plugin https://github.com/tpope/vim-commentary.git
  setup_vim_plugin https://github.com/tpope/vim-endwise.git
  setup_vim_plugin https://github.com/tpope/vim-surround.git
  setup_vim_plugin https://github.com/tpope/vim-vinegar.git
  setup_vim_plugin https://github.com/vim-airline/vim-airline.git
  setup_vim_plugin https://github.com/yangmillstheory/vim-snipe.git

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

  indent "Setup Complete" 0
  exit 0
}

main "$@"
