#!/bin/bash
# File              : setup.sh
# Copyright (C) 2021  Ace <teapot@aceforeverd.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -eE
set -o nounset

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

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
    -i            also install plugins
    -h            Display this message
    -v            Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvt:i" opt
do
  case $opt in

    t)  TYPE=$OPTARG ;;

    i)  INSTALL_PLUGINS=true ;;

    h)  usage; exit 0   ;;

    v)  echo "$(basename "$0") -- Version $__ScriptVersion"; exit 0   ;;

    * )  echo -e "\n  Option does not exist : $OPTARG\n"
          usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $((OPTIND-1))

ROOT=$(git rev-parse --show-toplevel)
DEIN_PATH=$ROOT/dein/repos/github.com/Shougo/dein.vim
DEIN_URL="https://github.com/Shougo/dein.vim.git"

if [ ! -d "$DEIN_PATH" ] ; then
    mkdir -p "$DEIN_PATH"
fi

echo -e "${GREEN}Start setting up plugin managers (dein.vim)${NC}"

echo -e "${GREEN}Installing dein.vim ...${NC}"
git clone "$DEIN_URL" "$DEIN_PATH" && \
    echo -e "${GREEN}dein.vim installed at $DEIN_PATH${NC}"
echo ""

echo -e "${GREEN}Plugin managers all setted${NC}"

CI=${CI:-}
NVIM_ARGS=
if [ -n "$CI" ]; then
    NVIM_ARGS='--headless'
fi

pushd "$ROOT"

if [[ $TYPE = "neovim" ]]; then
    ln -s vimrc.vim init.vim
else
    ln -s vimrc.vim vimrc
fi

if [[ -n "$INSTALL_PLUGINS" ]]; then
    if [[ "$TYPE" = "neovim" ]]; then
        echo -e "${GREEN}installing plugins for neovim ... ${NC}"
        nvim $NVIM_ARGS -u init.vim -c "call aceforeverd#util#install('qa!')"
        echo -e "${GREEN}all plugins installed${NC}"
    else
        echo -e "${GREEN}installing plugins for vim ... ${NC}"
        vim -c "set t_ti= t_te= nomore" -u vimrc -c "call aceforeverd#util#install('qa!')"
        echo -e "${GREEN}all plugins installed${NC}"
    fi
fi
popd
