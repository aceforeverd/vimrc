#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

GIT=$(command -v git)
WGET=$(command -v wget)

function help() {
    echo "$0 [options]"
    echo "options:"
    echo -e "\\t-h | --help: get this message"
    echo -e "\\tvim: install for vim"
    echo -e "\\tneovim: install for neovim"
}

if [ $# -le 0 ]; then
    help
    exit 1
fi

REPO=
VIMRC=

case "$1" in
    -h | --help)
        help
        exit 1
        ;;
    vim)
        REPO=$HOME/.vim
        VIMRC=$HOME/.vimrc
        ;;
    neovim)
        REPO=$HOME/.config/nvim
        VIMRC=$HOME/.config/nvim/init.vim
        ;;
    *)
        echo "Didn't match anything"
        help
        exit 1
esac


VIMPLUG=https:/raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
VIMPLUG_PATH=$REPO/autoload
DEIN_URL=https:/github.com/Shougo/dein.vim.git
DEIN_PATH=$REPO/dein/repos/github.com/Shougo/dein
VIMRC_PATH=$REPO
VIMRC_URL=https://github.com/aceforeverd/vimrc.git

NOTFOUND=1

function check_commands {
    if [ -z "$GIT" ] ; then
        echo 'git not found'
        exit ${NOTFOUND}
    fi

    if [ -z "$WGET" ]; then
        echo 'wget not found'
        exit ${NOTFOUND}
    fi
}

function install_vim_plug {
    if [ ! -d "$VIMPLUG_PATH" ]; then
        mkdir -p "$VIMPLUG_PATH"
    elif [ -f "${VIMPLUG_PATH}/plug.vim" ] ; then
        mv "${VIMPLUG_PATH}/plug.vim" "${VIMPLUG_PATH}/plug.vim.old"
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
    elif [ $(ls -al "$VIMRC_PATH") ] ; then
        mv "$VIMRC_PATH" "${VIMRC_PATH}.old"
    fi

    "$GIT" clone "$VIMRC_URL" "$VIMRC_PATH" && \
        echo "installed vimrc at $VIMRC_PATH"
    echo ""

    if [ -f "$VIMRC" ] ; then
        mv "$VIMRC" "$VIMRC.old"
        echo "moved your old vimrc file to $VIMRC.old"
    fi

    cp "$VIMRC_PATH/vimrc.vim" "$VIMRC"

    echo "=================================================================================="
    echo "installing plugins from vim-plug ..."
    vim -c "PlugInstall | q | q" && \
        echo "finished"
    echo -e "==================================================================================\n"

    echo "=================================================================================="
    echo "installing plugins from dein ..."
    vim -c "call dein#install() | q" && \
        echo "finished"
    echo -e "==================================================================================\n"

}


check_commands
install_vim_plug
install_dein
install_vimrc
