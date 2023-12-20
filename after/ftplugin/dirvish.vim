" Map `gh` to hide dot-prefixed files, 'R' to toggle
nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>
