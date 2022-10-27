# My vim config

[![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/aceforeverd/vimrc/CI/master?style=flat-square)](https://github.com/aceforeverd/vimrc/actions/workflows/ci.yml)
[![GitHub](https://img.shields.io/github/license/aceforeverd/vimrc?style=flat-square)](https://github.com/aceforeverd/vimrc/blob/master/LICENSE)
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/aceforeverd/vimrc?include_prereleases&style=flat-square)](https://github.com/aceforeverd/vimrc/releases)

---

## Requirements

+ Vim 8.0+ or Neovim 0.7.0+
+ git

## Optional Dependencies

+ nodejs env
+ rust env
+ python3.8+ env with [pynvim](https://github.com/neovim/pynvim) installed
+ sqlite3
+ searchers:
  - [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
+ taging: [ctags](https://github.com/universal-ctags/ctags), [gtags](https://www.gnu.org/software/global/)
+ utilities:
  - [fd](https://github.com/sharkdp/fd)
  - [code-minimap](https://github.com/wfxr/code-minimap)
  - [bat](https://github.com/sharkdp/bat)
  - [delta](https://github.com/dandavison/delta)
  - [vifm](https://vifm.info/)
+ [nerd font](https://github.com/ryanoasis/nerd-fonts)
+ C family tools: [clangd](https://clangd.llvm.org/), cpplint, clang-format, etc
+ lint/format tools:
  - [shellcheck](https://github.com/koalaman/shellcheck)
  - [shfmt](https://github.com/mvdan/sh)
  - [vim-vint](https://github.com/Vimjas/vint)

---

## Install

### 1. clone

```bash
git clone https://github.com/aceforeverd/vimrc.git "$CLONE_PATH"
```

where `$CLONE_PATH` is `$HOME/.vim` for vim and `$HOME/.config/nvim` for neovim

### 2. setup

run `setup.sh` inside clone path

```bash
cd "$CLONE_PATH"
# for neovim
./scripts/setup.sh
# or for vim
./scripts/setup.sh -t vim
```
