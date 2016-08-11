#!/bin/bash

##### Notes #####
# Map at the system level Caps Lock to Control
# Powerline/iTerm2 setup: https://coderwall.com/p/yiot4q/setup-vim-powerline-and-iterm2-on-mac-os-x
# Use brew pip (from Vim install):  pip install --user powerline-status (might not be necessary)
# Fonts: git clone https://github.com/powerline/fonts.git && cd fonts && ./install.sh
# Set iTerm2 font (non-ASCII too) to be: Inconsolata for powerline 14pt

DIR=$(cd $(/usr/bin/dirname $0) 2>/dev/null && pwd)

DOTFILES=(
  .bash_completion
  .bash_profile
  .gitconfig
  .gitignore
  .vim/syntax/go.vim
  .vimrc
  .bash_profile.d/rbenv
  .bash_profile.d/ssh-agent-config
)

FILE_SCRIPTS=(
  count_ctl_m.sh
  count_loc.sh
  remove_tabs.sh
  replace_space_underscore.sh
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

indent4() { sed 's/^/    /'; }

cleanup_dir() {
  dir="$1"
  rm -rf "$dir"
}

setup_powerline_fonts() {
  tmp_dir=$(mktemp -d /tmp/env_setup.XXXXXX)
  pushd $tmp_dir > /dev/null
  git clone -q https://github.com/powerline/fonts.git && cd fonts && ./install.sh | indent4
  popd > /dev/null
  trap "cleanup_dir ${tmp_dir}" EXIT
}

setup_vim_plugin() {
  plugin_git_url=$1
  plugin_name="$(basename $plugin_git_url .git)"
  if [ ! -d "$plugin_name" ]; then
    echo "    Setting up plugin: $plugin_name"
    git clone $plugin_git_url | indent4
  else
    echo "    Plugin $plugin_name already exists, skipping..."
  fi
}

symlink_dirs() {
  dir_prefix=$1
  target_dir=$2
  file_arr=("${!3}")

  for i in "${file_arr[@]}"; do
    target="$target_dir/$i"
    if [ ! -d "$(/usr/bin/dirname $target)" ]; then
      echo "    Base dir for $target does not exist, creating it..."
      mkdir -p $(/usr/bin/dirname $target)
    fi

    if [ -L "$target" ]; then
      echo "    $target is already symlinked."
    elif [ -e "$target" ]; then
      echo "    $target is already a file."
    else
      echo "    Symlinking $target."
      ln -s "$dir_prefix/$i" "$target"
    fi
  done
}

main() {
  ##### Setup VIM ####
  echo "Setting up Pathogen for VIM:"
  mkdir -p ${HOME}/.vim/autoload ${HOME}/.vim/bundle ${HOME}/.vim/syntax
  if [ ! -e "${HOME}/.vim/autoload/pathogen.vim" ]; then
    echo "    Pulling down Pathogen for VIM."
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  else
    echo "    Pathogen for VIM already exists, skipping..."
  fi
  # Powerline fonts
  if [ "$1" != "--no-fonts" ]; then
    echo "Setting up Powerline fonts:"
    setup_powerline_fonts
  fi

  # Plugins
  echo "Setting up VIM plugins:"
  cd ${HOME}/.vim/bundle
  setup_vim_plugin https://github.com/Raimondi/delimitMate.git
  setup_vim_plugin https://github.com/vim-airline/vim-airline.git
  setup_vim_plugin https://github.com/ctrlpvim/ctrlp.vim.git
  setup_vim_plugin https://github.com/tpope/vim-surround.git

  cd ${DIR}

  #### Setup Script/RC symlinks ####
  echo "Symlinking scripts and dotfiles:"
  mkdir -p $HOME/bin
  symlink_dirs "$DIR/dotfiles" $HOME DOTFILES[@]
  symlink_dirs "$DIR/file_scripts" "$HOME/bin" FILE_SCRIPTS[@]
  symlink_dirs "$DIR/ssh_config" "$HOME/bin" SSH_SCRIPTS[@]
  symlink_dirs "$DIR/git" "$HOME/bin" GIT_SCRIPTS[@]
  symlink_dirs "$DIR/vagrant_mgmt" "$HOME/bin" VAGRANT_SCRIPTS[@]

  echo "Setup Complete"
  exit 0
}

main "$@"
