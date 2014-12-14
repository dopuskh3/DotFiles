#!/bin/bash

function installlink(){
  if [ ! -d `dirname ~/$2` ]; then
    mkdir -p `dirname ~/$2`
  fi
  [ -e ~/$2 -a -L ~/$2 ] && rm ~/$2
  [ -e ~/$2 ] && (echo "Backup existing $2";  mv ~/$2 ~/$2-$(date +"%Y%m%d%H%M%S").bak)
  echo "Installing $1 to $2"
  ln -sf $(readlink -f $1) ~/$2

}

git submodule update --init --recursive

installlink zsh/zshrc .zshrc
installlink zsh/zsh   .zsh
installlink screen/screenrc .screenrc
installlink vim/vim .vim
installlink vim/vimrc .vimrc
installlink vim/vim .nvim
installlink vim/vimrc .nvimrc
installlink pylint/pylintrc .pylintrc
installlink python/pythonrc .pythonrc
installlink awesome .config/awesome
installlink X/Xsession .Xsession
installlink X/Xsession .xinitrc
installlink X/Xdefaults .Xdefaults
installlink bash/bashrc .bashrc
installlink tmux/tmux.conf .tmux.conf
installlink tmux/tmuxinator .tmuxinator
installlink git/gitconfig .gitconfig
installlink git .git
installlink git/git-template.txt .git-template.txt
installlink fonts/ .fonts
installlink terminator/config .config/terminator/config
installlink ctags/ctags .ctags

for install_file in */install.sh; do
  chmod +x $install_file
  if [ -x $install_file ]; then
    echo "Running $install_file."
    source $install_file
  fi
done

