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

function! aceforeverd#completion#init_cmp_source(src) abort
    if !exists('s:my_cmps')
        let s:my_cmps = {}
    endif

    " echodoc
    let g:echodoc#enable_at_startup = 1

    " setup common variables
    if a:src ==? 'deoplete'
        " functions
        let s:my_cmps['complete'] = function('deoplete#manual_complete')
        let s:my_cmps['document_hover'] = function('LanguageClient#textDocument_hover')

        " mappings
        inoremap <expr> <Plug>(MyIMappingBS) pumvisible() ? deoplete#smart_close_popup() . "\<C-h>" : delimitMate#BS()
        imap <expr> <Plug>MyIMappingCR pumvisible() ? deoplete#close_popup() . "\<CR>" : "<Plug>delimitMateCR"

        " variables
        let g:deoplete#enable_at_startup = 1
        let g:LanguageClient_autoStart = 1
        let g:coc_start_at_startup = 0

        call aceforeverd#completion#init_source_deoplete()
        call aceforeverd#completion#init_source_lc_neovim()
    elseif a:src ==? 'coc'
        let s:my_cmps['complete'] = function('coc#refresh')
        let s:my_cmps['document_hover'] = function('<SID>coc_hover')

        inoremap <expr> <Plug>(MyIMappingBS) pumvisible() ? "\<C-h>" : delimitMate#BS()
        imap <expr> <Plug>MyIMappingCR coc#_selected() ? coc#_select_confirm() : "<Plug>delimitMateCR"

        let g:deoplete#enable_at_startup = 0
        let g:coc_start_at_startup = 1
        let g:LanguageClient_autoStart = 0
        call aceforeverd#completion#init_source_coc()
    endif

    call aceforeverd#completion#init_source_common()
endfunction

function! aceforeverd#completion#init_source_common() abort
    " Tab complete
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ <SID>get_my_cmp_fn('complete')()
    inoremap <silent><expr> <S-TAB>
                \ pumvisible() ? "\<C-p>" :
                \ "\<S-TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    imap <BS> <Plug>(MyIMappingBS)
    " <CR>: close popup and save indent.
    " there seems issue with delimitMate and endwise tother.
    " a custom mapping with name '<Plug>*CR' seems a workaround
    imap <CR> <Plug>MyIMappingCR

    nnoremap <silent> K :call <SID>show_documentation()<CR>
endfunction


function! aceforeverd#completion#init_source_deoplete() abort
    " inoremap <expr> <C-h> deoplete#close_popup() . "\<C-h>"
    inoremap <expr> <C-g> deoplete#undo_completion()

    call deoplete#custom#option({
                \ 'auto_complete': v:true,
                \ 'ignore_case': v:true,
                \ 'smart_case': v:true,
                \ })
    if !has('nvim')
        call deoplete#custom#option('yarp', v:true)
    endif

    call deoplete#custom#var('omni', 'input_patterns', {
                \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
                \ 'java': '[^. *\t]\.\w*',
                \ 'php': '\w+|[^. \t]->\w*|\w+::\w*',
                \ 'javascript': '[^. *\t]\.\w*',
                \ 'typescript': '[^. *\t]\.\w*|\h\w*:',
                \ 'css': '[^. *\t]\.\w*',
                \ })

    call deoplete#custom#var('omni', 'function',{
                \ 'typescript': [ 'LanguageClient#complete' ],
                \ 'c': [ 'LanguageClient#complete'],
                \ 'cpp': [ 'LanguageClient#complete' ],
                \ 'rust': [ 'LanguageClient#complete'],
                \ 'php': [ 'LanguageClient#complete' ],
                \ })
    call deoplete#custom#var('terminal', 'require_same_tab', v:false)

    call deoplete#custom#option('ignore_sources', {
                \ '_': ['ale']
                \ })

    call deoplete#custom#source('look', {
                \ 'rank': 40,
                \ 'max_candidates': 15,
                \ })


    " deoplete-go
    let g:deoplete#sources#go#pointer = 1
    let g:deoplete#sources#go#builtin_objects = 1
    let g:deoplete#sources#go#unimported_packages = 1

    " neoinclude
    if !exists('g:neoinclude#exts')
        let g:neoinclude#exts = {}
    endif
    let g:neoinclude#exts.c = ['', 'h']
    let g:neoinclude#exts.cpp = ['', 'h', 'hpp', 'hxx']

    if !exists('g:neoinclude#paths')
        let g:neoinclude#paths = {}
    endif

    let g:neoinclude#paths.c = '.,'
                \ . '/usr/lib/gcc/*/*/include/,'
                \ . '/usr/local/include/,'
                \ . '/usr/lib/gcc/*/*/include-fixed/,'
                \ . '/usr/include/,,'

    let g:neoinclude#paths.cpp = '.,'
                \ . '/usr/include/c++/*/,'
                \ . '/usr/include/c++/*/*/,'
                \ . '/usr/include/c++/*/backward/,'
                \ . '/usr/local/include/,'
                \ . '/usr/lib/gcc/*/*/include/,'
                \ . '/usr/lib/gcc/*/*/include-fixed/,'
                \ . '/usr/lib/gcc/*/*/include/g++-v*/,'
                \ . '/usr/lib/gcc/*/*/include/g++-v*/backward,'
                \ . '/usr/lib/gcc/*/*/include/g++-v*/*/,'
                \ . '/usr/include/,,'

    let g:neosnippet#enable_snipmate_compatibility = 1
    imap <c-e> <Plug>(neosnippet_expand_or_jump)
    smap <c-e> <Plug>(neosnippet_expand_or_jump)
    xmap <c-e> <Plug>(neosnippet_expand_target)

    " denite
    augroup gp_denite
        autocmd!
        autocmd FileType denite call aceforeverd#settings#denite_settings()
        autocmd FileType denite-filter call aceforeverd#settings#denite_filter_settings()
    augroup END
endfunction


function! aceforeverd#completion#init_source_lc_neovim() abort
    let s:ccls_settings = {
                \ 'highlight': {'lsRanges': v:true},
                \ }
    let s:cquery_settings = {
                \ 'emitInactiveRegions': v:true,
                \ 'highlight': { 'enabled' : v:true},
                \ }
    let s:ccls_command = ['ccls', '-lint=' . json_encode(s:ccls_settings)]
    let s:cquery_command = ['cquery', '-lint=' . json_encode(s:cquery_settings)]
    let s:clangd_command = ['clangd', '-background-index']

    let g:LanguageClient_selectionUI = 'fzf'
    let g:LanguageClient_loadSettings = 1
    let g:LanguageClient_serverCommands = {
                \ 'rust': ['rustup', 'run', 'stable', 'rls'],
                \ 'typescript': ['javascript-typescript-stdio'],
                \ 'javascript': ['javascript-typescript-sdtio'],
                \ 'go': ['gopls'],
                \ 'yaml': ['yaml-language-server', '--stdio'],
                \ 'css': ['css-language-server', '--stdio'],
                \ 'sass': ['css-language-server', '--stdio'],
                \ 'less': ['css-language-server', '--stdio'],
                \ 'dockerfile': ['docker-langserver', '--stdio'],
                \ 'reason': ['ocaml-language-server', '--stdio'],
                \ 'ocaml': ['ocaml-language-server', '--stdio'],
                \ 'vue': ['vls'],
                \ 'lua': ['lua-lsp'],
                \ 'ruby': ['language_server-ruby'],
                \ 'c': s:clangd_command,
                \ 'cpp': s:clangd_command,
                \ 'vim': ['vim-language-server', '--stdio'],
                \ 'python': ['pyls'],
                \ 'dart': ['dart_language_server', '--force_trace_level=off'],
                \ 'haskell': ['hie', '--lsp'],
                \ 'sh': [ 'bash-language-server', 'start' ],
                \ }


    augroup gp_languageclent
        autocmd!
        autocmd FileType * call aceforeverd#completion#lsc_maps()
        autocmd FileType c,cpp call aceforeverd#completion#clangd_init()
    augroup END
endfunction


function! aceforeverd#completion#lsc_maps() abort
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> gy :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <buffer> <silent> gi :call LanguageClient#textDocument_implementation()<CR>
    nnoremap <buffer> <silent> gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
    nnoremap <buffer> gf :call LanguageClient#textDocument_formatting()<CR>

    " Rename - rn => rename
    noremap <leader>rn :call LanguageClient#textDocument_rename()<CR>

    " Rename - rc => rename camelCase
    noremap <leader>rc :call LanguageClient#textDocument_rename(
                \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>

    " Rename - rs => rename snake_case
    noremap <leader>rs :call LanguageClient#textDocument_rename(
                \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>

    " Rename - ru => rename UPPERCASE
    noremap <leader>ru :call LanguageClient#textDocument_rename(
                \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>
endfunction


function! aceforeverd#completion#clangd_init() abort
    let g:neosnippet#enable_complete_done = 1
    let g:neosnippet#enable_completed_snippet = 1
endfunction

function! aceforeverd#completion#init_source_coc() abort
    let g:coc_global_extensions = ['coc-vimlsp',
                \ 'coc-tag', 'coc-syntax',
                \ 'coc-snippets', 'coc-prettier',
                \ 'coc-lists', 'coc-floaterm',
                \ 'coc-highlight',
                \ 'coc-explorer', 'coc-eslint',
                \ 'coc-dictionary', 'coc-yank',
                \ 'coc-yaml', 'coc-tsserver',
                \ 'coc-rust-analyzer', 'coc-cmake',
                \ 'coc-pyright', 'coc-json',
                \ 'coc-html', 'coc-go',
                \ 'coc-sumneko-lua',
                \ 'coc-css', 'coc-clangd',
                \ 'coc-docker', 'coc-fish',
                \ 'coc-java', 'coc-diagnostic',
                \ 'coc-fzf-preview', 'coc-xml',
                \ 'coc-metals', 'coc-emoji',
                \ 'coc-toml',
                \ 'coc-word', 'coc-texlab',
                \ 'coc-esbonio', 'coc-sql',
                \ ]

    function! s:coc_maps() abort
        " Use `c-j` and `c-k` to navigate diagnostics
        nmap <silent> <c-k> <Plug>(coc-diagnostic-prev)
        nmap <silent> <c-j> <Plug>(coc-diagnostic-next)

        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nnoremap <Leader>gd gd
        nnoremap <Leader>gi gi
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Remap for rename current word
        nmap <leader>rn <Plug>(coc-rename)

        " Remap for format selected region
        xmap <leader>o  <Plug>(coc-format-selected)
        nmap <leader>o  <Plug>(coc-format-selected)

        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        " Remap for do codeAction of current line
        nmap <leader>ca  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)

        " Map function and class text objects
        " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)

        " Remap <C-f> and <C-b> for scroll float windows/popups.
        if has('nvim-0.4.0') || has('patch-8.2.0750')
            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif

        " select selections ranges, needs server support, like: coc-tsserver, coc-python
        nmap <silent> <Leader>rs <Plug>(coc-range-select)
        xmap <silent> <Leader>rs <Plug>(coc-range-select)

        nmap gl <Plug>(coc-openlink)
    endfunction

    augroup gp_coc
        autocmd!

        autocmd User CocNvimInit call <SID>coc_maps()
        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        autocmd FileType c,cpp,objcpp nnoremap <Leader>af :<C-u>CocCommand clangd.switchSourceHeader<cr>
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    nnoremap <leader>k <cmd>call CocActionAsync('highlight')<cr>

    highlight CocHighlightText cterm=bold cterm=bold guibg=#5e5e61 gui=bold,undercurl
    augroup coc_custom_highlight
        autocmd!
        autocmd ColorScheme * highlight CocHighlightText cterm=bold guibg=#5e5e61 gui=bold,undercurl
    augroup END

    " Use `:Format` to format current buffer
    command! -nargs=0 CocFormat :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? CocFold :call CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 CocOR :call CocAction('runCommand', 'editor.action.organizeImport')

    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>x :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>c :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>o :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>p :<C-u>CocListResume<CR>

    nnoremap <space>e :<C-u>CocCommand explorer<CR>

    nnoremap <silent> <space>l :<C-u>CocList -A --normal yank<CR>
    nnoremap <silent> <space>v :<C-u>CocList services<CR>
    nnoremap <silent> <space><space> :<C-u>CocList<CR>

    " coc-highlight
    nnoremap <Leader>cp :call CocAction('pickColor')<CR>
    nnoremap <Leader>cf :call CocAction('colorPresentation')<CR>

    " coc-snippets
    imap <expr> <C-l> coc#expandableOrJumpable() ? "<Plug>(coc-snippets-expand-jump)" : "\<C-l>"
    vmap <c-j> <Plug>(coc-snippets-select)
endfunction

" ulility functions
function! s:is_dir(path) abort
    return !empty(a:path) && (isdirectory(a:path) ||
                \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:path)))
endfunction

function! s:check_back_space() abort "{{{
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~# '\s'
endfunction "}}}


function! s:get_my_cmp_fn(key) abort
    return get(s:my_cmps, a:key, "\<Nop>")
endfunction

function! s:show_documentation() abort
    if (index(['vim','help'], &filetype) >= 0)
        let l:name = expand('<cword>')
        try
            execute 'help ' . l:name
        catch /.*/
            echo 'no help for ' . l:name
            echoerr
        endtry
    else
        call <SID>get_my_cmp_fn('document_hover')()
    endif
endfunction

function! s:coc_hover() abort
    if (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . ' ' . expand('<cword>')
    endif
endfunction
