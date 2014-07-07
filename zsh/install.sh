#!/bin/bash -ex

zsh_dir=$(readlink -f `dirname ${BASH_SOURCE}`)

ln -sf ${zsh_dir}/third-party/antigen/antigen.zsh ${zsh_dir}/zsh/modules/
