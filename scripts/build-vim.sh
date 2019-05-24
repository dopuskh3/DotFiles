#!/bin/bash
builddir=${HOME}/build
vimbuilddir=${builddir}/vim

if [ "$(uname)" != "Linux" ]; then
  echo "Only compatible with linux"
  exit 1
fi

sudo apt-get remove -y --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common

sudo apt-get install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev

if [ ! -d ${vimbuilddir} ]; then
  mkdir -p ${builddir}
  git clone https://github.com/vim/vim ${vimbuilddir}
  pushd ${vimbuilddir}
else
  pushd ${vimbuilddir}
  git pull && git fetch
fi


./configure \
  --enable-multibyte \
  --enable-perlinterp=dynamic \
  --enable-rubyinterp=dynamic \
  --with-ruby-command=/usr/bin/ruby \
  --enable-pythoninterp=dynamic \
  --with-python-config-dir=$(python-config --configdir) \
  --enable-python3interp \
  --with-python3-config-dir=$(python3-config --configdir) \
  --enable-luainterp \
  --with-luajit \
  --enable-cscope \
  --enable-gui=auto \
  --with-features=huge \
  --with-x \
  --enable-fontset \
  --enable-largefile \
  --disable-netbeans \
  --with-compiledby="fvisconte@gmail.com" \
  --enable-fail-if-missing

make
sudo make install
