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
WGET=$(command -v wget)

VIMPLUG=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
VIMPLUG_PATH=$HOME/.vim/autoload
DEIN_URL=https://github.com/Shougo/dein.vim.git
DEIN_PATH=$HOME/.vim/dein.vim/repos/github.com/Shougo/dein.vim
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
    elif [ -f "${VIMPLUG_PATH}/plug.vim" ] ; then
        rm "${VIMPLUG_PATH}/plug.vim"
    fi

    "$WGET" "$VIMPLUG" -O "$VIMPLUG_PATH"/plug.vim && \
        echo "vim plug installed at $VIMPLUG_PATH"
    echo ""
}

function install_dein {
    if [ ! -d "$DEIN_PATH" ]; then
        mkdir -p "$DEIN_PATH"
    else
        rm -rf "$DEIN_PATH"
    fi

    "$GIT" clone "$DEIN_URL" "$DEIN_PATH" && \
        echo "dein installed at $DEIN_PATH"
    echo ""
}

function install_vimrc {
    if [ ! -d "$VIMRC_PATH" ] ; then
        mkdir -p "$VIMRC_PATH"
    else
        rm -rf "$VIMRC_PATH"
    fi

    "$GIT" clone "$VIMRC_URL" "$VIMRC_PATH" && \
        echo "installed vimrc at $VIMRC_PATH"
    echo ""

    if [ -f $HOME/.vimrc ] ; then
        mv $HOME/.vimrc $HOME/.vimrc-backup
        echo "moved your old vimrc file to $HOME/.vimrc-backup"
    fi

    echo "source ~/.vim_runtime/vimrc" > ~/.vimrc

    echo "=================================================================================="
    echo "installing plugins from vim-plug"
    echo "=================================================================================="
    vim -c "PlugInstall | q" && \
        echo "finished"
    echo "=================================================================================="

    echo "=================================================================================="
    echo "installing plugins from dein"
    vim -c "call dein#install() | q" && \
        echo "finished"
    echo "=================================================================================="

}


install_vim_plug
install_dein
install_vimrc
