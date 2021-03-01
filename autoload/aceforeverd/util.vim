" setup all vim plugins and everything other needed
" should only called during installing
function! aceforeverd#util#init() abort
    call dein#install()
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
