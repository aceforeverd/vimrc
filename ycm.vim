" configuration for YouCompleteMe

let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
let g:ycm_global_ycm_extra_conf = '~/.vim_runtime/templates/ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

if !exists("g:cm_semantic_triggers")
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers =  {
    \   'c' : ['->', '.'],
    \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
    \             're!\[.*\]\s'],
    \   'ocaml' : ['.', '#'],
    \   'cpp,objcpp' : ['->', '.', '::'],
    \   'perl' : ['->'],
    \   'php' : ['->', '::'],
    \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
    \   'ruby' : ['.', '::'],
    \   'lua' : ['.', ':'],
    \   'erlang' : [':'],
    \ }

" typescript
let g:ycm_semantic_triggers['typescript'] = ['.']

" neco-ghc
autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc
let g:ycm_semantic_triggers['haskell'] = ['.']

" }}}

