#!/bin/bash

# In case if deamon doesn't start make sure to give Full Disk Permission in System Preferences -> Security & Privacy -> Privacy.
set -e
set -x

LAUNCH_DAEMONS_DIR="/Library/LaunchDaemons"
CONFIG_FILE_NAME=com.activity.maintainer.plist

sudo cp $CONFIG_FILE_NAME $LAUNCH_DAEMONS_DIR
sudo chown root $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
sudo chgrp wheel $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
sudo chmod o-w $LAUNCH_DAEMONS_DIR/*
launchctl load -w $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
