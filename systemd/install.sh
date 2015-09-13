#!/bin/bash

systemctl --user daemon-reload
pushd $HOME/.config/systemd/user
systemctl --user enable *.service
