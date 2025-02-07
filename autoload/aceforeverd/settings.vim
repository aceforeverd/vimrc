" Copyright (C) 2021  Ace <teapot@aceforeverd.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

function! aceforeverd#settings#my_init() abort
    if !exists('g:my_cmp_source')
        " nvim_lsp: neovim builtin lsp
        " coc:      coc.nvim
        " vim_lsp:  vim-lsp
        " deplete:  deplete.nvim
        if has('nvim-0.6.0')
            let g:my_cmp_source = 'nvim_lsp'
        else
            let g:my_cmp_source = 'coc'
        endif
    endif

    " default to vim-dirvish by 'dirvish'
    " or u can set 'netrw' to use netrw with vim-vinegar enhancements
    let g:my_dir_viewer = get(g:, 'my_dir_viewer', 'dirvish')

    let g:my_statusline = get(g:, 'my_statusline', 'lualine')

    let g:my_name = get(g:, 'my_name', 'Ace')
    let g:my_email = get(g:, 'my_email', 'teapot@aceforeverd.com')
endfunction

const s:sonokai_styles = ['atlantis', 'andromeda', 'shusia', 'espresso']

function! aceforeverd#settings#sonokai_pre() abort
    if has('nvim')
        let random_idx = v:lua.require('aceforeverd.util.random').random(0, len(s:sonokai_styles) - 1)
        let g:sonokai_style = s:sonokai_styles[random_idx]
    else
        let g:sonokai_style = 'andromeda'
    endif

    " NOTE: need a font supports cursive italics installed, and setted t_ZH & t_ZR correctly
    let g:sonokai_enable_italic = 1
    let g:sonokai_better_performance = 1
    let g:sonokai_diagnostic_text_highlight = 1
    let g:sonokai_diagnostic_virtual_text = 'colored'
endfunction

function! aceforeverd#settings#sonokai_post() abort
    " token from everforest
    highlight! Visual term=reverse ctermbg=52 guibg=#543a48
    highlight! VisualNOS ctermbg=52 guibg=#543a48
endfunction

" common highlight customization
function! aceforeverd#settings#hl_groups() abort
    " highlights for line numbers
    highlight LineNr ctermfg=176 guifg=#9fa0cc
    highlight CursorLineNr ctermfg=180 guifg=#9734ff
    highlight CursorLineFold ctermfg=180 guifg=#f69c51

    " sonokai link 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' default to 'CurrentWord'
    " for lsp enabled buffer, 'Lspreference*' groups are used
    highlight LspReferenceText cterm=bold gui=bold guibg=#5e5e5f
    highlight LspReferenceRead cterm=underline gui=undercurl guibg=#5e5e5f
    highlight LspReferenceWrite cterm=bold,underline gui=bold,undercurl guibg=#5e5e9f

    " old two vim groups
    highlight illuminatedWord guibg=#5e5e5e
    highlight illuminatedCurWord guibg=#5e5e8f
    " new three neovim groups
    highlight IlluminatedWordText cterm=bold gui=bold guibg=#5e5e5e
    highlight IlluminatedWordRead cterm=underline gui=undercurl guibg=#5e5e5f
    highlight IlluminatedWordWrite cterm=bold,underline gui=bold,undercurl guibg=#5e5e9f

    " coc highlight groups
    highlight CocHighlightText cterm=bold gui=bold guibg=#5e5e5e
    highlight CocHighlightRead cterm=underline gui=undercurl guibg=#5e5e5f
    highlight CocHighlightWrite cterm=bold,underline gui=bold,undercurl guibg=#5e5e9f

    " tree view
    highlight DirvishSuffix ctermfg=250 ctermbg=235 guifg=#e4e3e1 guibg=#312c2b

    " gitsigns
    highlight GitSignsCurrentLineBlame ctermfg=246 guifg=#b3b3b3

    " inlay hints
    if hlexists('LspInlayHint') && get(g:, 'colors_name') =~# '^github'
        highlight LspInlayHint cterm=italic gui=italic
    else
        highlight LspInlayHint cterm=italic ctermfg=110 gui=italic guifg=#8b949e guibg=#363c44
    endif
    highlight link lspInlayHintsType LspInlayHint
    highlight link CocInlayHint LspInlayHint
endfunction

function! aceforeverd#settings#basic_color() abort
    set background=dark

    if has('nvim')
        " NOT SURE if NVIM_TUI_ENABLE_TRUE_COLOR still useful
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    endif

    if has('termguicolors')
        " should work on out-of-box for recent neovims or vims
        " I do not intend to check more
        set termguicolors
    endif

    " if $TERM=~#'xterm-256color' || $TERM=~#'screen-256color' || $TERM=~#'xterm-color' || has('gui_running')
        "Credit joshdick
        "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.

        "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
        "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
        " if empty($TMUX)

        "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
        "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
        "< https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
        " if has('termguicolors') && (has('nvim') || empty($TMUX))
        "     set termguicolors
        " endif
        " endif
    " endif
endfunction
