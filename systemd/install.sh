#!/bin/bash

pushd $HOME/.config/systemd/user
systemctl --user enable *.service
systemctl --user daemon-reload
