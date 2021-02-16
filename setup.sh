#!/bin/bash

CURRENT_PATH="$(pwd)"
DOTFILES=(.shell .aliases .bash_profile .bashrc .common .macos .nanorc .zprofile .zshrc)

for DOTFILE in ${DOTFILES[*]}
do
    rm -f ~/${DOTFILE}
    ln -s ${CURRENT_PATH}/${DOTFILE} ~/${DOTFILE}
done

# Start activity maintainer deamon
cd ~/.shell/daemons/activity_maintainer/
sudo ./start.sh