#!/bin/bash

# update your RB
apt-get update
apt-get upgrade -y

# install some additional packages
apt-get install -y curl git mercurial binutils bzr bison libgmp3-dev screen build-essential

# enable ssh (enabled after next reboot)
touch /boot/ssh
