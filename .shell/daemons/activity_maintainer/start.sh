#!/bin/bash

set -e
set -x

LAUNCH_DAEMONS_DIR="/Library/LaunchDaemons"
CONFIG_FILE_NAME=com.activity.maintainer.plist

sudo cp $CONFIG_FILE_NAME $LAUNCH_DAEMONS_DIR
sudo chown root $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
sudo chgrp wheel $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
sudo chmod o-w $LAUNCH_DAEMONS_DIR/*
launchctl load -w $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME

# To unload deamon run:
# launchctl unload -w $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME