#!/usr/bin/env python3
import logging
import os
import datetime
import subprocess
import shutil
import copy

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)
mkdirp = os.makedirs

def homedir():
    return os.environ["HOME"]

def dotfiledir():
    return os.path.join(os.path.dirname(__file__), '..')

def _environ():
    env = copy.copy(os.environ)
    env['DOT_FILES'] = dotfiledir()

def sh(command):
    log.info("Running {}".format(command))
    subprocess.check_call(command, shell=True, env=_environ())

def zsh(command):
    log.info("Running zsh command: {}".format(command))
    subprocess.check_call(['zsh', '-c', command], env=_environ())

def rmr(directory):
    directory = os.path.normpath(directory)
    print(directory)
    if os.path.exists(directory):
        log.info("Removing {}".format(directory))
        shutil.rmtree(directory)


def install(source, target):
    s = os.path.normpath(os.path.abspath(os.path.join(dotfiledir(), source)))
    t = os.path.normpath(os.path.abspath(os.path.join(homedir(), target)))
    if not os.path.exists(s):
        raise IOError("{} does not exists.".format(s))
    print(os.path.exists(t))
    if os.path.exists(t) or os.path.islink(t):
        print("File exists" + t)
        if os.path.islink(t) and os.readlink(t) == s:
            log.info("{} and {} are already the same files".format(s, t))
            return
        else:
            backup_name = '{}.bak-{}'.format(t, datetime.datetime.now().isoformat())
            log.info("Backing up {} to {}".format(t, backup_name))
            os.rename(t, backup_name)
    if not os.path.isdir(os.path.dirname(t)):
        log.info("Creating {} directory".format(os.path.dirname(t)))
        os.makedirs(os.path.dirname(t))
    log.info('{} -> {}'.format(s, t))
    return os.symlink(s, t)
