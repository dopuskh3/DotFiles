#!/usr/bin/env python3
import logging
import os
import datetime
import subprocess
import shutil

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)
mkdirp = os.makedirs

def homedir():
    return os.environ["HOME"]

def currentdir():
    return os.path.dirname(__file__)

def sh(command):
    log.info("Running {}".format(command))
    subprocess.check_call(command, shell=True)

def rmr(directory):
    directory = os.path.normpath(directory)
    print(directory)
    if os.path.exists(directory):
        log.info("Removing {}".format(directory))
        shutil.rmtree(directory)


def install(source, target):
    s = os.path.normpath(os.path.abspath(os.path.join(currentdir(), source)))
    t = os.path.normpath(os.path.abspath(os.path.join(homedir(), target)))
    if not os.path.exists(t):
        raise IOError("{} does not exists.".format(s))

    if os.path.exists(t):
        if os.path.islink(t) and os.readlink(t) == s:
            log.info("{} and {} are already the same files".format(s, t))
            return
        else:
            backup_name = '{}.bak-{}'.format(t, datetime.datetime.now().isoformat())
            log.info("Backing up {} to {}".format(t, backup_name))
            os.rename(t, backup_name)
    if not os.path.isdir(os.path.dirname(t)):
        log.info("Creating {} directory".format(os.path.dirname(t)))
        os.makedirs(os.path.dirname(t))
    log.info('{} -> {}'.format(s, t))
    return os.symlink(s, t)

if __name__ == "__main__":
    sh('rm -rf ~/.vim/ && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim')
    install('vim/neovim-init', '.config/nvim/init.vim')
    install('vim/vimrc', '.vimrc')
    sh('vim +BundleInstall')
    install('zsh/zshrc', '.zshrc')
    install('tmux/tmux.conf', '.tmux.conf')
