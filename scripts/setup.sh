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
INSTALL_PLUGINS=

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
    -s            skip plugin install, just setup plugin managers
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

    s)  INSTALL_PLUGINS=true ;;

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

pushd "$ROOT"
if [[ -n "$INSTALL_PLUGINS" ]]; then
    if [[ "$TYPE" = "neovim" ]]; then
        ln -s vimrc.vim init.vim
        nvim --headless -u "$ROOT/vimrc.vim" -c "call dein#install()" -c "qa!"
    else
        ln -s vimrc.vim vimrc
        vim -E -c "set t_ti= t_te= nomore"  -u "$ROOT/vimrc.vim" -c "call dein#install()" -c "qa!"
    fi
fi
popd
