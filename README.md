# My vim config
---
## Requirements
+ vim >= 8 or neovim >= 0.3
+ git
---
## Install
### clone
```bash
git clone https://github.com/aceforeverd/vimrc.git "$CLONE_PATH"
```
where `$CLONE_PATH` is `$HOME/.vim` for vim and `$HOME/.config/nvim` for neovim

### set up plugin managers
run `setup.sh` inside clone path
```bash
cd "$CLONE_PATH"
./scripts/setup.sh
```

### install plugins
1. open vim/neovim
2. for vim plug, type
    ```vimscript
    :PlugInstall
    ```
3. for dein.vim, type
    ```vimscript
    :call dein#install()
    ```
### enjoy
---
## Notes
### plugin managers used:
1. [vim plug](https://github.com/junegunn/vim-plug.git)
2. [dein.vim](https://github.com/Shougo/dein.vim.git)
