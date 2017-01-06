#!/bin/bash
dotdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${dotdir}/dotlib.bash

git submodule update --init --recursive

dot-install zsh/zshrc .zshrc
dot-install zsh/zsh   .zsh
dot-install screen/screenrc .screenrc
dot-install vim/vim .vim
dot-install vim/vimrc .vimrc
dot-install vim/vim .nvim
dot-install vim/vimrc .nvimrc
dot-install pylint/pylintrc .pylintrc
dot-install python/pythonrc .pythonrc
dot-install awesome .config/awesome
dot-install X/Xsession .Xsession
dot-install X/Xsession .xinitrc
dot-install X/Xsession .xinitrc
dot-install X/Xdefaults .Xdefaults
dot-install bash/bashrc .bashrc
dot-install tmux/tmux.conf .tmux.conf
dot-install tmux/tmuxinator .tmuxinator
dot-install git/gitconfig .gitconfig
dot-install git .git
dot-install git/git-template.txt .git-template.txt
dot-install fonts/ .fonts
dot-install fonts/fonts.conf .fonts.conf
dot-install terminator/config .config/terminator/config
dot-install ctags/ctags .ctags
dot-install scripts/spotify-command bin/spotify-command
dot-install X/colors .config/Xcolors
dot-install systemd/user .config/systemd/user
dot-install yaourt/yaourtrc .yaourtrc

if [ -d ${dotdir}/urxvt-font-size ]; then
  pushd urxvt-font-size
  git fetch --all
  git reset --hard origin/master
  popd
else
  git clone https://github.com/majutsushi/urxvt-font-size
fi
