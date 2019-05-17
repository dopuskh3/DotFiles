#!/usr/bin/env python3
from lib import (
        sh,
        install
        )

sh('rm -rf ~/.vim/ && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim')
install('vim/neovim-init', '.config/nvim/init.vim')
install('vim/vimrc', '.vimrc')
sh('vim +BundleInstall')
install('zsh/zshrc', '.zshrc')
install('tmux/tmux.conf', '.tmux.conf')
