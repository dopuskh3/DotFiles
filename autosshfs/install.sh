#!/bin/bash
tmp_dir=`mktemp -d`
pushd $tmp_dir
sudo apt-get install keychain ssh-askpass sshfs autofs
git clone https://github.com/hellekin/autosshfs.git
cd autosshfs && sudo make install
sudo autosshfs-user add $(id -un)
popd
