#!/bin/bash -ex
zsh_dir=`dirname $0`/
abs_zsh_dir=`readlink -f ${zsh_dir}`
ln -sf ${abs_zsh_dir}/antigen/antigen.zsh ${abs_zsh_dir}/zsh/modules/
