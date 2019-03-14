#!/bin/bash -
# File              : install.sh
# script is deprecated

set -eE
set -o nounset                                  # Treat unset variables as an error

GIT=$(command -v git)

EDITOR=
REPO=
VIMRC=

__ScriptVersion="1.1"

function check_editor {
    case "$EDITOR" in
        vim)
            REPO=$HOME/.vim
            VIMRC=$HOME/.vimrc
            ;;
        nvim | neovim)
            REPO=$HOME/.config/nvim
            VIMRC=$HOME/.config/nvim/init.vim
            ;;
        *)
            echo "$EDITOR Didn't match anything(vim/nvim)"
            exit 1
    esac
}

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
    echo "Usage :  $(basename "$0") [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version
    -f            install for vim/neovim"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvf:" opt
do
    case $opt in

        h)
            usage
            exit 0
            ;;

        v)
            echo "$0 -- Version $__ScriptVersion"
            exit 0
            ;;

        f)
            EDITOR=$OPTARG
            check_editor
            ;;


        *)
            echo -e "\n  Option does not exist : $OPTARG\n"
            usage
            exit 1
            ;;

    esac    # --- end of case ---
done
shift $((OPTIND-1))

VIMPLUG=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
VIMPLUG_PATH=$REPO/autoload
DEIN_URL=https://github.com/Shougo/dein.vim.git
DEIN_PATH=$REPO/dein/repos/github.com/Shougo/dein
VIMRC_PATH=$REPO
VIMRC_URL=https://github.com/aceforeverd/vimrc.git

NOTFOUND=1

function check_commands {
    if [ -z "$GIT" ] ; then
        echo 'git not found'
        exit ${NOTFOUND}
    fi
}

function install_vim_plug {
    if [ ! -d "$VIMPLUG_PATH" ]; then
        mkdir -p "$VIMPLUG_PATH"
    elif [ -f "${VIMPLUG_PATH}/plug.vim" ] ; then
        echo "Moving you old plug.vim as plug.vim.old"
        mv "${VIMPLUG_PATH}/plug.vim" "${VIMPLUG_PATH}/plug.vim.old"
    fi

    curl -fLo "$VIMPLUG_PATH"/plug.vim --create-dirs "$VIMPLUG" && \
        echo "vim plug installed as $VIMPLUG_PATH/plug.vim"
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
        echo "cloned vimrc at $VIMRC_PATH"
    echo ""

    if [ -f "$VIMRC" ] ; then
        mv "$VIMRC" "$VIMRC.old"
        echo "moved your old vimrc file to $VIMRC.old"
    fi

    cp "$VIMRC_PATH/vimrc.vim" "$VIMRC"

    echo "=================================================================================="
    echo "installing plugins from vim-plug ..."
    "$EDITOR" -c "PlugInstall | q | q" && \
        echo "finished"
    echo -e "==================================================================================\n"

    echo "=================================================================================="
    echo "installing plugins from dein ..."
    "$EDITOR" -c "call dein#install() | q" && \
        echo "finished"
    echo -e "==================================================================================\n"

}


check_commands
install_vim_plug
install_dein
install_vimrc
