" setup all vim plugins and everything other needed
" should only called during installing
function! aceforeverd#util#install() abort
    try
        call dein#install()
    catch /.*/
    endtry
    echomsg 'Dein plugins installed'
    execute 'PlugInstall --sync'
    echomsg 'Vim-Plug plugins installed'
    if g:my_cmp_source ==? 'coc'
        " reload plugins so vim can find newly installed plugin like coc.nvim
        execute 'runtime! plugin/**/*.vim'
        execute 'CocUpdateSync'
        echomsg 'Coc Plugins installed'
    endif
endfunction

" update all plugins managed by different plug manager
function! aceforeverd#util#update() abort
    try
        call dein#update()
    catch /.*/
    endtry
    execute 'PlugUpdate'
    execute 'CocUpdate'
endfunction
