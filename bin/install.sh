#!/bin/bash -
#===============================================================================
#
#          FILE: install.sh
#
#         USAGE: ./install.sh
#
#   DESCRIPTION: install script
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ACE (), 
#  ORGANIZATION: 
#       CREATED: 08/04/2017 06:12:24 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

GIT=$(command -v git)
WGET=$(command -t wget)

VIMPLUG=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
INSTALL_PATH=$HOME/.vim/autoload
DEIN_URL=https://github.com/Shougo/dein.vim.git
DEIN_PATH=$INSTALL_PATH/dein.vim/repos/github.com/Shougo/dein.vim
VIMRC_PATH=$HOME/.vim_runtime
VIMRC_URL=https://github.com/aceforeverd/vimrc.git

NOTFOUND=1

function check_commands {
    if [ -z ${GIT} ] ; then
        echo 'git not found'
        exit ${NOTFOUND}
    fi

    if [ -z ${WGET} ]; then
        echo 'wget not found'
        exit ${NOTFOUND}
    fi
}

function install_vim_plug {
    if [ ! -d "$VIMPLUG_PATH" ]; then
        mkdir -p "$VIMPLUG_PATH"
    fi

    "$WGET" "$VIMPLUG" -o "$VIMPLUG_PATH"/plug.vim && \
        echo "vim plug installed at $VIMPLUG_PATH"
    echo ""
}

function install_dein {
    if [ ! -d "$DEIN_PATH" ]; then
        mkdir -p "$DEIN_PATH"
    fi

    "$GIT" clone "$DEIN_URL" "$DEIN_PATH" && \
        echo "dein installed at $DEIN_PATH"
    echo ""
}

function install_vimrc {
    if [ ! -d "$VIMRC_PATH" ] ; then
        mkdir -p "$VIMRC_PATH"
    fi

    "$GIT" clone "$VIMRC_URL" "$VIMRC_PATH" && \
        echo "installed vimrc at $VIMRC_PATH"
    echo ""

    echo "source ~/.vim_runtime/vimrc" >> ~/.vimrc
}

function lanuch_vim {
    vim -c 'call dein#install() | PlugInstall '
}

install_vim_plug
install_dein
install_vimrc
lanuch_vim
