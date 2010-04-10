#!/usr/bin/env bash
set -x 


# zsh 
function installlink(){
    
    [ -e ~/$2 ] && (echo "Backup existing $2";  mv ~/$2 ~/$2-$(date +"%Y%m%d%H%M%S").bak)
    ln -sf $(readlink -f $1) ~/$2

}

installlink zsh/zshrc .zshrc
installlink screen/screenrc .screenrc
installlink vim/vim .vim
installlink vim/vimrc .vimrc
installlink pylint/pylintrc .pylintrc
