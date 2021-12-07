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
        if has('nvim-0.6.0')
            let g:my_cmp_source = 'nvim_lsp'
        else
            let g:my_cmp_source = 'coc'
        endif
    endif

    let g:my_autopair = get(g:, 'my_autopair', 'delimitmate')

    let g:my_neosnippet_enable = get(g:, 'my_neosnippet_enable', 1)
    let g:my_ultisnips_enable = get(g:, 'my_ultisnips_enable', 1)
    let g:my_vsnip_enable = get(g:, 'my_vsnip_enable', 1)

    let g:my_status_line = get(g:, 'my_status_line', 'feline')
    let g:my_buffer_line = get(g:, 'my_buffer_line', 'bufferline')

    if !exists('g:my_name')
        let g:my_name = 'Ace'
    endif
    if !exists('g:my_email')
        let g:my_email = 'teapot@aceforeverd.com'
    endif
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

function! aceforeverd#settings#sonokai() abort
    if has('nvim')
        let g:sonokai_enable_italic = 1
        if has('nvim-0.6.0')
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

function! aceforeverd#settings#basic_color() abort
    set background=dark

    " if $TERM=~#'xterm-256color' || $TERM=~#'screen-256color' || $TERM=~#'xterm-color' || has('gui_running')
        "Credit joshdick
        "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
        "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
        "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
        " if empty($TMUX)
        if has('nvim')
            "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
            let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
        endif
        "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
        "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
        "< https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
        if has('termguicolors') && (has('nvim') || empty($TMUX))
            set termguicolors
        endif
        " endif
    " endif
endfunction
