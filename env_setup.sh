#!/bin/bash

DIR=$(cd $(/usr/bin/dirname $0) 2>/dev/null && pwd)

DOTFILES=(
  .bash_completion
  .bash_profile
  .gitconfig
  .gitignore
  .vim/syntax/go.vim
  .vimrc
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

setup_vim_plugin() {
  plugin_name=$1
  plugin_git_url=$2
  if [ ! -d "$plugin_name" ]; then
    echo "    Setting up plugin: $plugin_name"
    git clone $plugin_git_url
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
  mkdir -p ${HOME}/.vim/autoload ${HOME}/.vim/bundle
  if [ ! -e "${HOME}/.vim/autoload/pathogen.vim" ]; then
    echo "    Pulling down Pathogen for VIM."
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  else
    echo "    Pathogen for VIM already exists, skipping..."
  fi

  # Plugins
  echo "Setting up VIM plugins:"
  cd ${HOME}/.vim/bundle
  setup_vim_plugin delimitMate https://github.com/Raimondi/delimitMate.git
  cd ${DIR}

  #### Setup Script/RC symlinks ####
  echo "Symlinking scripts and dotfiles:"
  symlink_dirs "$DIR/dotfiles" $HOME DOTFILES[@]
  symlink_dirs "$DIR/file_scripts" "$HOME/bin" FILE_SCRIPTS[@]
  symlink_dirs "$DIR/ssh_config" "$HOME/bin" SSH_SCRIPTS[@]
  symlink_dirs "$DIR/git" "$HOME/bin" GIT_SCRIPTS[@]
  symlink_dirs "$DIR/vagrant_mgmt" "$HOME/bin" VAGRANT_SCRIPTS[@]

  echo "Setup Complete"
  exit 0
}

main
