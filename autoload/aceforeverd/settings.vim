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

    let g:my_autopair = get(g:, 'my_autopair', 'delimitmate')

    let g:with_ultisnips = get(g:, 'with_ultisnips', 1)
    let g:with_vsnip = get(g:, 'with_vsnip', 0)

    let g:my_statusline = get(g:, 'my_statusline', 'feline')
    let g:my_tabline = get(g:, 'my_tabline', 'bufferline')

    let g:with_hlslens = get(g:, 'with_hlslens', 1)
    let g:with_registers = get(g:, 'with_registers', 1)

    let g:my_name = get(g:, 'my_name', 'Ace')
    let g:my_email = get(g:, 'my_email', 'teapot@aceforeverd.com')
endfunction

function! aceforeverd#settings#denite_filter_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

function! aceforeverd#settings#denite_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'

    " Change matchers.
    call denite#custom#source(
                \ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
    call denite#custom#source(
                \ 'file/rec', 'matchers', ['matcher/cpsm'])

    " Change default action.
    call denite#custom#kind('file', 'default_action', 'split')

    " Add custom menus
    let s:menus = {}

    let s:menus.zsh = {
                \ 'description': 'Edit your import zsh configuration'
                \ }
    let s:menus.zsh.file_candidates = [
                \ ['zshrc', '~/.config/zsh/.zshrc'],
                \ ['zshenv', '~/.zshenv'],
                \ ]

    let s:menus.my_commands = {
                \ 'description': 'Example commands'
                \ }
    let s:menus.my_commands.command_candidates = [
                \ ['Split the window', 'vnew'],
                \ ['Open zsh menu', 'Denite menu:zsh'],
                \ ['Format code', 'FormatCode', 'go,python'],
                \ ]

    call denite#custom#var('menu', 'menus', s:menus) 
    " Ag command on grep source
    call denite#custom#var('grep', 'command', ['dag'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Ripgrep command on grep source
    call denite#custom#var('grep', 'command', ['drg'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Change ignore_globs
    call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
                \ [ '.git/', '.ropeproject/', '__pycache__/',
                \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

endfunction

function! aceforeverd#settings#sonokai_pre() abort
    if has('nvim')
        let g:sonokai_enable_italic = 1
        if has('nvim-0.7.0')
            let g:sonokai_style = 'espresso'
        else
            let g:sonokai_style = 'shusia'
        endif
    else
        " italic in vim looks wired
        let g:sonokai_disable_italic_comment = 1
        let g:sonokai_style = 'andromeda'
    endif

    let g:sonokai_better_performance = 1
    let g:sonokai_diagnostic_text_highlight = 1
    let g:sonokai_diagnostic_virtual_text = 'colored'
endfunction

" common highlight customization
function! aceforeverd#settings#hl_groups() abort
    " sonokai link 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' default to 'CurrentWord'
    " for lsp enabled buffer, 'Lspreference*' groups are used
    highlight LspReferenceText cterm=bold gui=bold guibg=#5e5e5f
    highlight LspReferenceRead cterm=underline gui=undercurl guibg=#5e5e5f
    highlight LspReferenceWrite cterm=bold,underline gui=bold,undercurl guibg=#5e5e9f
    highlight illuminatedWord guibg=#5e5e5e
    highlight illuminatedCurWord guibg=#5e5e8f

    " coc highlight groups
    highlight CocHighlightText cterm=bold gui=bold guibg=#5e5e5e
    highlight CocHighlightRead cterm=underline gui=undercurl guibg=#5e5e5f
    highlight CocHighlightWrite cterm=bold,underline gui=bold,undercurl guibg=#5e5e9f

    " tree view
    highlight DirvishSuffix ctermfg=250 ctermbg=235 guifg=#e4e3e1 guibg=#312c2b

    " gitsigns
    highlight GitSignsCurrentLineBlame ctermfg=246 guifg=#b3b3b3
endfunction

function! aceforeverd#settings#basic_color() abort
    set background=dark

    if !has('termguicolors')
        echomsg 'termguicolors not available'
        return
    endif

    if has('nvim')
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
        set termguicolors
    else
        if empty($TMUX) && ($TERM=~#'xterm-256color' || $TERM=~#'screen-256color' || $TERM=~#'xterm-color' || $TERM=~#'xterm-kitty' || has('gui_running'))
            set termguicolors
        endif
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

function! aceforeverd#settings#glaive() abort
    call glaive#Install()
    Glaive codefmt plugin[mappings]
endfunction

" little utilities to open current file editing/file under cursor in netrw/dirvish with in browser
"
" @param type:
"    1. 'b' -> file current editing
"    2. 'c' -> file under cursor, apply to netrw & dirvish
""
function! aceforeverd#settings#open_with_browser(type) abort
    if a:type ==? 'b'
        " file current editing
        let s:file_path = expand('%:p')
    elseif a:type ==? 'c'
        " file under cursor
        let s:file_path = expand('<cfile>:p')
    endif

    if !filereadable(s:file_path)
        echomsg 'file ' . s:file_path . ' not exists!'
        return
    endif

    execute '!open ' . s:file_path
endfunction

function! aceforeverd#settings#vim_go() abort
    let g:go_fmt_autosave = 0
    let g:go_mod_fmt_autosave = 0
    let g:go_doc_popup_window = 1
    let g:go_term_enabled = 1
    let g:go_def_mapping_enabled = 0
    let g:go_doc_keywordprg_enabled = 0
    let g:go_gopls_enabled = 0
endfunction

function! aceforeverd#settings#clap(root_path) abort
    let g:clap_enable_yanks_provider = 1
    let g:clap_provider_yanks_history = a:root_path . '/clap_yanks_history'
    nnoremap <leader>cl :Clap<CR>
    nnoremap <leader>cf :Clap files<CR>
    nnoremap <leader>cb :Clap buffers<cr>
    nnoremap <Space>l :Clap yanks<cr>
endfunction
