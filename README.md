# My vim config

[![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/aceforeverd/vimrc/CI/master?style=flat-square)](https://github.com/aceforeverd/vimrc/actions/workflows/ci.yml)
[![GitHub](https://img.shields.io/github/license/aceforeverd/vimrc?style=flat-square)](https://github.com/aceforeverd/vimrc/blob/master/LICENSE)
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/aceforeverd/vimrc?include_prereleases&style=flat-square)](https://github.com/aceforeverd/vimrc/releases)

---

## Requirements

+ Vim 8.0+ or Neovim 0.7.0+
+ git

## Optional Dependencies (Debian for example)

+ [nerd font](https://github.com/ryanoasis/nerd-fonts)
+ utilities:
  - [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [fd](https://github.com/sharkdp/fd)
  - [bat](https://github.com/sharkdp/bat)
  - [delta](https://github.com/dandavison/delta)
  - [vifm](https://vifm.info/)
  - sqlite3 & libsqlite3-dev
  - [ctags](https://github.com/universal-ctags/ctags), [gtags](https://www.gnu.org/software/global/)
+ nodejs env
+ rust env
+ python3.8+ env with [pynvim](https://github.com/neovim/pynvim)

---

## Install

### 1. clone

```bash
git clone https://github.com/aceforeverd/vimrc.git "$CLONE_PATH"
```

where `$CLONE_PATH` is `$HOME/.vim` for vim and `$HOME/.config/nvim` for neovim

### 2. setup

`make install`
