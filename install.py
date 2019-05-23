#!/usr/bin/env python3
from lib import (
        sh,
        zsh,
        install,
        cleanall,
        )

### Install vim
if cleanall():
    sh('rm -rf ~/.vim')

sh('[ -e ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim')

install('vim/vimrc', '.vimrc')
sh('vim +BundleInstall +qall')


### Install oh-my-zsh
sh('sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')
install('zsh/zshrc', '.zshrc')
zsh('[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions')
zsh('PLUGIN_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/dopuskh3 && mkdir -p ${PLUGIN_DIR} && ln -sf $DOT_FILES/zsh/dopuskh3.plugin.zsh $PLUGIN_DIR/')

### Tmux
install('tmux/tmux.conf', '.tmux.conf')
