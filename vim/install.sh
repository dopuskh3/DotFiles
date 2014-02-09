#!/bin/bash

function exfail () {
  echo $* 1>&2
  exit 1
}

if [ ! -d ~/.vim/bundle/vundle ]; then
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle || exfail "Can't clone undle."
fi
vim +BundleInstall +qall
