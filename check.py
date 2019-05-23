#!/usr/bin/env python3
from lib import (
        which,
        log
        )

log.info("Checking for requirements...")
which('fpp', 'vim', 'fzf', 'tmux', 'rg')
