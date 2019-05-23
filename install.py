#!/usr/bin/env python3
from lib import (
        sh,
        zsh,
        install
        )

### Install vim
#sh('rm -rf ~/.vim/ && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim')
install('vim/neovim-init', '.config/nvim/init.vim')
install('vim/vimrc', '.vimrc')
sh('python -m pip install --user neovim')
sh('python3.7 -m pip install --user neovim')
sh('nvim +BundleInstall +qall')


### Install oh-my-zsh
sh('sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')
install('zsh/zshrc', '.zshrc')
install('tmux/tmux.conf', '.tmux.conf')
zsh('[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions')
#sh('zsh -c \'PLUGIN_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins}/dopuskh3 && ln -sf ~/DotFiles/zsh/dopuskh3.plugin.zsh $PLUGIN_DIR\'')
zsh('PLUGIN_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/dopuskh3 && mkdir -p ${PLUGIN_DIR} && ln -sf $DOT_FILES/zsh/dopuskh3.plugin.zsh $PLUGIN_DIR/')
