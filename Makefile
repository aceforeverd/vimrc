MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR  := $(dir $(MAKEFILE_PATH))

install:
	@if [ $(MAKEFILE_DIR) = "${HOME}/.config/nvim/" ] ; then \
	    ln -s vimrc.vim init.vim ; \
	elif [ $(MAKEFILE_DIR) = "${HOME}/.vim/" ] ; then \
	    ln -s vimrc.vim vimrc ; \
	else \
	    echo "pls place the source code in ~/.config/nvim or ~/.vim" ; \
	    exit 1 ; \
	fi

vint:
	./scripts/vint-check.sh
