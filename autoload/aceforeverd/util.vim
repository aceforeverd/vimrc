" setup all vim plugins and everything other needed
" should only called during installing
function! aceforeverd#util#init() abort
    call dein#install()
    echomsg "Dein plugins installed"
    execute "normal :PlugInstall<CR>"
    echomsg "Vim-Plug plugins installed"
    if g:my_cmp_source ==? 'coc'
        execute "normal :CocUpdateSync<CR>"
        echomsg "Coc Plugins installed"
    endif
endfunction
