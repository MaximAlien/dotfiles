#!/bin/bash

set -e
set -x

LAUNCH_DAEMONS_DIR="/Library/LaunchDaemons"
CONFIG_FILE_NAME=com.activity.maintainer.plist

launchctl unload -w $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
sudo rm $LAUNCH_DAEMONS_DIR/$CONFIG_FILE_NAME
