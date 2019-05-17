#!/usr/bin/env python3
from lib import (
        sh,
        install
        )

def brew_install(package):
    sh('brew install {}'.format(package))

brew_install(' '.join([
    'tmux',
    'fzf',
    'fpp',
    'neovim',
    'cmake',
    ]))
