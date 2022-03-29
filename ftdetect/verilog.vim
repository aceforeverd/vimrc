" vint: -ProhibitAutocmdWithNoGroup

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" Note: should not use augroup in ftdetect (see :help ftdetect)
au BufRead,BufNewFile *.verilog,*.vlg set filetype=verilog

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save
