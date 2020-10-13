#!/bin/bash
# File              : setup.sh
# Date              : 13.03.2019
# Last Modified Date: 13.03.2019


# the script set up vim plugin manager for vim/neovim:
# 1. dein.vim (https://github.com/Shougo/dein.vim.git)
# 2. vimplug (https://github.com/junegunn/vim-plug.git)

set -eE
set -o nounset

cd "$(dirname "$0")"

TYPE=neovim

__ScriptVersion="1.1.0"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
    echo "Usage :  $(basename "$0") [options] [--]

    Options:
    -t            vim type, neovim or vim, default to neovim
    -h|help       Display this message
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvt:" opt
do
  case $opt in

    t)  TYPE=$OPTARG ;;

    h)  usage; exit 0   ;;

    v)  echo "$(basename "$0") -- Version $__ScriptVersion"; exit 0   ;;

    * )  echo -e "\n  Option does not exist : $OPTARG\n"
          usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $((OPTIND-1))

ROOT=$(git rev-parse --show-toplevel)
DEIN_PATH=$ROOT/dein/repos/github.com/Shougo/dein.vim
VIMPLUG_PATH=$ROOT/autoload
DEIN_URL="https://github.com/Shougo/dein.vim.git"
VIMPLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

if [ ! -d "$DEIN_PATH" ] ; then
    mkdir -p "$DEIN_PATH"
fi

echo -e "\033[0;32mStart setting up plugin managers (vim plug & dein.vim)\033[0m"

echo -e "\033[0;32mInstalling vim plug ...\033[0m"
curl -fLo "$VIMPLUG_PATH/plug.vim" --create-dirs "$VIMPLUG" && \
    echo -e "\033[1;32mvim plug installed as $VIMPLUG_PATH/plug.vim\033[0m"
echo ""

echo -e "\033[0;32mInstalling dein.vim ...\033[0m"
git clone "$DEIN_URL" "$DEIN_PATH" && \
    echo -e "\033[1;32mdein.vim installed at $DEIN_PATH\033[0m"
echo ""

echo -e "\033[1;32mPlugin managers all setted"

if [[ $TYPE = "neovim" ]] ; then
    # nvim -u "$ROOT/vimrc.vim" -E -c "call dein#install()" -c "PlugInstall" -c 'q'
    ln -s "$ROOT/vimrc.vim" "$ROOT/init.vim"
elif [[ $TYPE = "vim" ]] ; then
    # vim -u "$ROOT/vimrc.vim" -E -c "call dein#install()" -c "PlugInstall" -c 'q'
    # ln -s "$ROOT/vimrc.vim" "$HOME/.vim/vimrc"
    echo
fi
echo -e "\033[1;32mPlugins installed"
