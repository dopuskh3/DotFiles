#!/bin/bash 

function installlink(){
    [ -e ~/$2 -a -L ~/$2 ] && rm ~/$2 && echo "Removed old symlink ~/$2"
    [ -e ~/$2 ] && (echo "Backup existing $2";  mv ~/$2 ~/$2-$(date +"%Y%m%d%H%M%S").bak)
    echo "Installing $1 to $2"
    ln -sf $(readlink -f $1) ~/$2

}

installlink zsh/zshrc .zshrc
installlink zsh/zsh   .zsh
installlink screen/screenrc .screenrc
installlink vim/vim .vim
installlink vim/vimrc .vimrc
installlink pylint/pylintrc .pylintrc
installlink python/pythonrc .pythonrc
installlink awesome .config/awesome
installlink X/Xsession .Xsession
installlink X/Xsession .xinitrc
installlink bash/bashrc .bashrc
