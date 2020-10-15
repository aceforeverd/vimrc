#!/bin/bash
# File              : setup.sh
# Date              : 13.03.2019
# Last Modified Date: 13.03.2019


# the script set up vim plugin manager for vim/neovim:
# 1. dein.vim (https://github.com/Shougo/dein.vim.git)
# 2. vimplug (https://github.com/junegunn/vim-plug.git)

set -eE
set -o nounset

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

cd "$(dirname "$0")"

TYPE=neovim
INSTALL_PLUGINS=true

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

while getopts ":hvt:s" opt
do
  case $opt in

    t)  TYPE=$OPTARG ;;

    s)  INSTALL_PLUGINS= ;;

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

echo -e "${GREEN}Start setting up plugin managers (vim plug & dein.vim)${NC}"

echo -e "${GREEN}Installing vim plug ...${NC}"
curl -fLo "$VIMPLUG_PATH/plug.vim" --create-dirs "$VIMPLUG" && \
    echo -e "${GREEN}vim plug installed as $VIMPLUG_PATH/plug.vim${NC}"
echo ""

echo -e "${GREEN}Installing dein.vim ...${NC}"
git clone "$DEIN_URL" "$DEIN_PATH" && \
    echo -e "${GREEN}dein.vim installed at $DEIN_PATH${NC}"
echo ""

echo -e "${GREEN}Plugin managers all setted${NC}"

pushd "$ROOT"
if [[ -n "$INSTALL_PLUGINS" ]]; then
    if [[ "$TYPE" = "neovim" ]]; then
        ln -s vimrc.vim init.vim
        echo -e "${GREEN}installing dein plugins for neovim${NC}"
        nvim --headless -u "$ROOT/vimrc.vim" -c "call dein#install()" -c "qa!"
        nvim --headless -u "$ROOT/vimrc.vim" -c "PlugUpdate" -c 'qa!'
    else
        ln -s vimrc.vim vimrc
        echo -e "${GREEN}installing dein plugins for vim${NC}"
        vim -E -c "set t_ti= t_te= nomore" -u "$ROOT/vimrc.vim" -c "call dein#install()" -c "qa!"
    fi
fi
popd
