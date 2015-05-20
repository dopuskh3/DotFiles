#!/bin/bash
dotdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function dot-install(){
  if [ ! -d `dirname ~/$2` ]; then
    mkdir -p `dirname ~/$2`
  fi
  [ -e ~/$2 -a -L ~/$2 ] && rm ~/$2
  [ -e ~/$2 ] && (echo "Backup existing $2";  mv ~/$2 ~/$2-$(date +"%Y%m%d%H%M%S").bak)
  echo "Installing $1 to $2"
  ln -sf $(readlink -f $1) ~/$2
}
