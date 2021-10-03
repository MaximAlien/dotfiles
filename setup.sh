#!/bin/bash

set -e
set -x

CURRENT_PATH="$(pwd)"
DOTFILES=( \
    .shell \
    .aliases \
    .bash_profile \
    .bashrc \
    .common \
    .macos \
    .nanorc \
    .zprofile \
    .zshrc \
    .gitconfig \
    .gitignore_global \
    .gitcommit_template \
    .swiftlint.yml \
)

for DOTFILE in ${DOTFILES[*]}
do
    rm -f ~/${DOTFILE}
    ln -s ${CURRENT_PATH}/${DOTFILE} ~/${DOTFILE}
done

# Start activity maintainer deamon
cd ~/.shell/daemons/activity_maintainer/
sudo ./start.sh

# To view Xcode code snippets use Command + Shift + L
cp -r ${CURRENT_PATH}/snippets/*.codesnippet ~/Library/Developer/Xcode/UserData/CodeSnippets/

installUtilities() {
    echo "Installing utilities..."

    UTILITIES=( \
        swiftlint \
    )

    for UTILITIY in ${UTILITIES[*]}
    do
        brew reinstall ${UTILITIY}
    done

    echo "Finished installing utilities."
}

installApplications() {
    echo "Installing applications..."

    APPLICATIONS=( \
        alfred \
        visual-studio-code \
        skype \
        sourcetree \
        spotify \
        virtualbox \
        pycharm-ce \
        wireshark \
        vlc \
        openoffice \
        telegram \
        rescuetime \
        sublime-text \
        powershell \
        viber \
        airserver \
        android-file-transfer \
        macdown \
        gpac \
        selfcontrol \
        machoview \
        android-studio \
        angry-ip-scanner \
        hex-fiend \
        cmake \
        db-browser-for-sqlite \
        iterm2 \
        grandperspective \
        hopper-debugger-server \
        ios-app-signer \
        google-chrome \
    )

    for APPLICATION in ${APPLICATIONS[*]}
    do
        brew reinstall --cask ${APPLICATION}
    done

    echo "Finished installing applications."
}

case $1 in
"u")
    installUtilities
    ;;
"a")
    installApplications
    ;;
*)
    echo "Dependencies will not be installed."
    ;;
esac