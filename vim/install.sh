#!/bin/bash
VIM_DIR=$HOME/DotFiles/vim

function exfail () {
  echo $* 1>&2
  exit 1
}

if [ ! -d ~/.vim/bundle/vundle ]; then
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle || exfail "Can't clone undle."
fi

for theme in `ls ${VIM_DIR}/third-party/thomorrow-theme/vim/colors/*.vim`; do
  theme_name=`basename $theme`
  ln  -sfv $theme ~/.vim/colors/${theme_name}
done

vim +BundleInstall +qall
