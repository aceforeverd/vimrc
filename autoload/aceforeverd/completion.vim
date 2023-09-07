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

    " setup common variables
    let s:my_cmps['complete'] = function('coc#refresh')
    let s:my_cmps['document_hover'] = function('<SID>coc_hover')

    inoremap <expr> <Plug>(MyIMappingBS) pumvisible() ? "\<C-h>" : delimitMate#BS()

    " only confirm if coc pum visible and a item is selected
    " vim default popup menu plays well with delimitMate, I don't check it
    imap <expr> <Plug>MyIMappingCR coc#pum#visible() && coc#pum#info().index >= 0 ?
                \ coc#pum#confirm() :
                \ "<Plug>delimitMateCR"

    let g:coc_start_at_startup = 1
    call aceforeverd#completion#init_source_coc()

    call aceforeverd#completion#init_source_common()
endfunction

function! aceforeverd#completion#init_source_common() abort
    " Tab complete
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ coc#pum#visible() ? coc#pum#next(1) :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ <SID>get_my_cmp_fn('complete')()
    inoremap <silent><expr> <S-TAB>
                \ pumvisible() ? "\<C-p>" :
                \ coc#pum#visible() ? coc#pum#prev(1) :
                \ "\<S-TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    imap <BS> <Plug>(MyIMappingBS)
    " <CR>: close popup and save indent.
    " there seems issue with delimitMate and endwise tother.
    " a custom mapping with name '<Plug>*CR' seems a workaround
    imap <CR> <Plug>MyIMappingCR

    nnoremap <silent> K :call <SID>show_documentation()<CR>
endfunction


function! aceforeverd#completion#init_source_coc() abort
    let g:coc_global_extensions = [
                \ 'coc-vimlsp', 'coc-syntax',
                \ 'coc-snippets', 'coc-lists', 'coc-floaterm',
                \ 'coc-highlight', 'coc-git',
                \ 'coc-explorer', 'coc-word',
                \ 'coc-yank', 'coc-sumneko-lua',
                \ 'coc-yaml', 'coc-tsserver',
                \ 'coc-rust-analyzer', 'coc-cmake',
                \ 'coc-pyright', 'coc-json',
                \ 'coc-html', 'coc-go',
                \ 'coc-css', 'coc-clangd',
                \ 'coc-java', 'coc-diagnostic',
                \ 'coc-xml', 'coc-toml', 'coc-emoji',
                \ 'coc-esbonio', 'coc-sql',
                \ 'coc-zig',
                \ ]

    augroup gp_coc
        autocmd!

        autocmd User CocNvimInit call <SID>coc_on_attach()
        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')
        autocmd FileType c,cpp,objcpp nnoremap <Leader>af :<C-u>CocCommand clangd.switchSourceHeader<cr>
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " TODO: setlocal only for buffers that coc attached
    if exists('&tagfunc')
        " resolve tag with coc, fallback to tag search if not found
        set tagfunc=CocTagFunc
    endif
    set formatexpr=CocAction('formatSelected')

    nnoremap <leader>k <cmd>call CocActionAsync('highlight')<cr>

    " Use `:Format` to format current buffer
    command! -nargs=0 CocFormat :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? CocFold :call CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 CocOR :call CocAction('runCommand', 'editor.action.organizeImport')

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
    nnoremap <silent> <space>q <Cmd>CocDiagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>E :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>C :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>s :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>S :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>p :<C-u>CocListResume<CR>

    nnoremap <space>e :<C-u>CocCommand explorer<CR>
    nnoremap <space>B :<C-u>CocList buffers<CR>

    nnoremap <silent> <space>l :<C-u>CocList -A --normal yank<CR>
    nnoremap <silent> <space>v :<C-u>CocList services<CR>
    nnoremap <silent> <space><space> :<C-u>CocList<CR>

    " coc-highlight
    nnoremap <Leader>cp :call CocAction('pickColor')<CR>
    nnoremap <Leader>cP :call CocAction('colorPresentation')<CR>

    " coc-snippets
    vmap <c-j> <Plug>(coc-snippets-select)
    " snippet jump keymaps auto removed on snippet deactivate
    let g:coc_snippet_next = '<c-j>'
    let g:coc_snippet_prev = '<c-k>'
endfunction

function! s:coc_on_attach() abort
    " ==================================
    " keymaps
    " ==================================

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

    " range format
    xmap <cr>  <Plug>(coc-format-selected)
    " format operator, or use gq
    nmap g<cr>  <Plug>(coc-format-selected)

    " Remap for do codeAction of selected region
    xmap <leader>cc  <Plug>(coc-codeaction-selected)
    nmap <leader>cc  <Plug>(coc-codeaction-selected)

    " code action for current file
    nmap <leader>cA  <Plug>(coc-codeaction)
    " Remap keys for applying code actions at the cursor position
    nmap <leader>ca  <Plug>(coc-codeaction-cursor)
    " Remap keys for apply code actions affect whole buffer
    nmap <leader>cb  <Plug>(coc-codeaction-source)
    " Apply the most preferred quickfix action to fix diagnostic on the current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Remap keys for applying refactor code actions
    nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
    xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
    nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

    " Run the Code Lens action on the current line
    nmap <leader>cl <Plug>(coc-codelens-action)

    " select selections ranges, needs server support, like: coc-tsserver, coc-python
    nmap <silent> <Leader>rs <Plug>(coc-range-select)
    xmap <silent> <Leader>rs <Plug>(coc-range-select)

    nmap gl <Plug>(coc-openlink)
    nnoremap <leader>co :call CocAction('ShowOutgoingCalls')
    nnoremap <leader>ci :call CocAction('ShowIncommingCalls')

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
endfunction

function! aceforeverd#completion#help() abort
    let l:name = expand('<cword>')
    try
        execute 'help ' . l:name
    catch /.*/
        echo 'no help for ' . l:name
        echoerr
    endtry
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
    call <SID>get_my_cmp_fn('document_hover')()
endfunction

function! s:coc_hover() abort
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

function! aceforeverd#completion#wider() abort
    call wilder#setup({
                \ 'modes': [':', '/', '?'],
                \ 'enable_cmdline_enter': 0,
                \ })
    " use command pallette style
    call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_palette_theme({
                \ 'border': 'round',
                \ 'max_height': '75%',
                \ 'min_height': 0,
                \ 'prompt_position': 'bottom',
                \ 'reverse': 1,
                \ })))
    " fuzzy find
    call wilder#set_option('pipeline', [
                \   wilder#branch(
                \     wilder#cmdline_pipeline({
                \       'language': 'python',
                \       'fuzzy': 1,
                \     }),
                \     wilder#python_search_pipeline({
                \       'pattern': wilder#python_fuzzy_pattern(),
                \       'sorter': wilder#python_difflib_sorter(),
                \       'engine': 're',
                \     }),
                \   ),
                \ ])
    " find file pipeline
    call wilder#set_option('pipeline', [
                \   wilder#branch(
                \     wilder#python_file_finder_pipeline({
                \       'file_command': ['fd', '-tf'],
                \       'dir_command': ['fd', '-td'],
                \       'filters': ['fuzzy_filter', 'difflib_sorter'],
                \     }),
                \     wilder#cmdline_pipeline(),
                \     wilder#python_search_pipeline(),
                \   ),
                \ ])
endfunction
