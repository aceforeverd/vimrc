""
" setup plugins with minpac
""

function! aceforeverd#plugin#setup()
    call s:init_cmds()

    call s:minpac()
endfunction

" 'packadd!' variant that (!) is silent
function! s:pack_add(bang, name) abort
    " silent(!) applied just in case exception in vim, if plugin not installed yet
    if a:bang
        silent! execute 'packadd! ' .. a:name
    else
        execute 'packadd! ' .. a:name
    endif
endfunction

function! s:init_cmds() abort
    " tiny wrapper for :packadd
    " good thing is use :PackAdd! to ignore any errors and do not terminate,
    " this may helpful when first install and plugins not installed yet
    command! -bang -nargs=1 PackAdd call s:pack_add(<bang>0, <f-args>)

    command! MinUpdate call minpac#update()
    command! MinStatus call minpac#status()
    command! MinClean call minpac#clean()
endfunction

function! s:minpac() abort
    if has('nvim')
        let s:pack_path = stdpath('data') . '/site/'
    else
        let s:pack_path = $HOME . '/.vim'
    endif
    let s:minpac_path = s:pack_path . '/pack/minpac/opt/minpac'

    if empty(glob(s:minpac_path))
        call system(join([ 'git', 'clone', 'https://github.com/k-takata/minpac', s:minpac_path ]))
    endif

    packadd minpac

    call minpac#init({'dir': s:pack_path})

    call minpac#add('Shougo/context_filetype.vim', {'type': 'opt'})
    call minpac#add('Shougo/neco-syntax', {'type': 'opt'})
    call minpac#add('Shougo/neco-vim', {'type': 'opt'})
    call minpac#add('Shougo/echodoc.vim', {'type': 'opt'})

    call minpac#add('voldikss/vim-floaterm')

    call minpac#add('tpope/vim-endwise')
    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-ragtag')
    call minpac#add('tpope/vim-dispatch')
    call minpac#add('tpope/vim-rhubarb')
    call minpac#add('tpope/vim-abolish')
    call minpac#add('tpope/vim-repeat')
    call minpac#add('tpope/vim-bundler')
    call minpac#add('tpope/vim-rails')
    call minpac#add('tpope/vim-fireplace')
    call minpac#add('tpope/vim-scriptease')
    call minpac#add('tpope/vim-unimpaired')
    call minpac#add('tpope/vim-salve')
    call minpac#add('tpope/vim-eunuch')
    call minpac#add('tpope/vim-speeddating')
    call minpac#add('tpope/vim-obsession')
    call minpac#add('tpope/vim-tbone')
    call minpac#add('tpope/vim-dadbod')
    call minpac#add('tpope/vim-projectionist')
    call minpac#add('tpope/vim-sleuth')
    call minpac#add('tpope/vim-apathy')
    call minpac#add('tpope/vim-characterize')

    call minpac#add('lambdalisue/suda.vim')

    " snippets
    call minpac#add('honza/vim-snippets')

    " interface
    call minpac#add('ryanoasis/vim-devicons')
    call minpac#add('mhinz/vim-startify')
    call minpac#add('ntpeters/vim-better-whitespace')
    call minpac#add('liuchengxu/vista.vim')
    call minpac#add('wincent/terminus')
    call minpac#add('vifm/vifm.vim')
    call minpac#add('justinmk/vim-gtfo')

    " motion
    call minpac#add('rhysd/clever-f.vim')
    call minpac#add('justinmk/vim-sneak')
    call minpac#add('andymass/vim-matchup')
    " Tools
    call minpac#add('editorconfig/editorconfig-vim')
    call minpac#add('will133/vim-dirdiff')
    call minpac#add('dstein64/vim-startuptime')
    call minpac#add('aceforeverd/gen_tags.vim', {'type': 'opt'})
    call minpac#add('AndrewRadev/bufferize.vim')
    call minpac#add('tyru/open-browser.vim')
    call minpac#add('wincent/ferret')
    call minpac#add('ojroques/vim-oscyank')

    call minpac#add('alpertuna/vim-header')
    " code format
    call minpac#add('sbdchd/neoformat')
    call minpac#add('junegunn/vim-easy-align')
    " run/debug/test
    call minpac#add('vim-test/vim-test')
    call minpac#add('skywind3000/asyncrun.vim')
    call minpac#add('skywind3000/asynctasks.vim')
    call minpac#add('jpalardy/vim-slime')
    call minpac#add('preservim/vimux')

    " VCS
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('junegunn/gv.vim')
    call minpac#add('rhysd/committia.vim')

    " search
    call minpac#add('junegunn/fzf', {
                \ 'do': { -> fzf#install() }
                \ })
    call minpac#add('junegunn/fzf.vim')

    call minpac#add('mbbill/undotree')
    call minpac#add('jamessan/vim-gnupg')

    call minpac#add('tomtom/tcomment_vim')
    call minpac#add('chrisbra/recover.vim')
    " text object manipulate
    call minpac#add('AndrewRadev/splitjoin.vim')
    call minpac#add('AndrewRadev/sideways.vim')
    call minpac#add('AndrewRadev/tagalong.vim')
    call minpac#add('AndrewRadev/switch.vim')
    call minpac#add('chrisbra/NrrwRgn')
    call minpac#add('machakann/vim-sandwich')
    " Debug
    call minpac#add('puremourning/vimspector')

    " Typescript
    call minpac#add('HerringtonDarkholme/yats.vim')

    " vimL
    call minpac#add('mhinz/vim-lookup')

    call minpac#add('tweekmonster/exception.vim')
    call minpac#add('tweekmonster/helpful.vim')
    " markdown
    call minpac#add('mzlogin/vim-markdown-toc')
    call minpac#add('iamcco/markdown-preview.nvim', {
                \ 'do': { -> mkdp#util#install() }
                \ })

    call minpac#add('rust-lang/rust.vim')
    " Tmux
    call minpac#add('tmux-plugins/vim-tmux')
    call minpac#add('christoomey/vim-tmux-navigator')

    " gentoo
    call minpac#add('gentoo/gentoo-syntax')

    call minpac#add('chrisbra/csv.vim')

    call minpac#add('cdelledonne/vim-cmake')

    call minpac#add('k-takata/minpac', {'type': 'opt'})
    call minpac#add('jalvesaq/Nvim-R', {'type': 'opt'})
    call minpac#add('mg979/docgen.vim')

    " Latex
    call minpac#add('lervag/vimtex', {'type': 'opt'})

    " vim only
    " Go
    call minpac#add('fatih/vim-go', {'type': 'opt'})
    call minpac#add('itchyny/lightline.vim', {'type': 'opt'})
    call minpac#add('airblade/vim-gitgutter', {'type': 'opt'})

    call minpac#add('justinmk/vim-dirvish', {'type': 'opt'})
    call minpac#add('tpope/vim-vinegar', {'type': 'opt'})

    call minpac#add('neoclide/coc.nvim', {'type': 'opt',
                \ 'rev': 'release' })
    call minpac#add('antoinemadec/coc-fzf', {'type': 'opt'})
    call minpac#add('neoclide/coc-neco', {'type': 'opt'})

    " load opt plugins
    " ignore errors because plugins may not installed from first time

    " auto pair
    call minpac#add('raimondi/delimitmate', {'type': 'opt'})
    call minpac#add('cohama/lexima.vim', {'type': 'opt'})

    call minpac#add('kristijanhusak/vim-dadbod-ui')

    call minpac#add('sainnhe/sonokai', {'type': 'opt'})
    call minpac#add('chrisbra/unicode.vim')

    let g:polyglot_disabled = ['sensible', 'autoindent', 'go']
    let g:vim_json_syntax_conceal = 1
    call minpac#add('sheerun/vim-polyglot')

    call minpac#add('kovisoft/slimv')

    call minpac#add('aceforeverd/vim-translator', {'rev': 'dev'})

    " load plugins
    PackAdd! cfilter
    " early load colorschem, ref https://github.com/sainnhe/gruvbox-material/issues/60
    PackAdd! sonokai

    if g:my_cmp_source !=? 'coc'
        PackAdd! context_filetype.vim
        PackAdd! neco-syntax
        PackAdd! neco-vim
        PackAdd! echodoc.vim
    endif

    if !has('nvim')
        PackAdd! vim-go
        call aceforeverd#settings#vim_go()
    endif

    if g:my_dir_viewer ==? 'dirvish'
        PackAdd! vim-dirvish
        " sort folders at top
        let g:dirvish_mode = ':sort /^.*[\/]/'

    elseif g:my_dir_viewer ==? 'netrw'
        PackAdd! vim-vinegar
    endif

    if !has('nvim-0.5.0')
        PackAdd! lightline.vim

        call aceforeverd#statusline#lightline()

        PackAdd! vim-gitgutter
        omap ih <Plug>(GitGutterTextObjectInnerPending)
        omap ah <Plug>(GitGutterTextObjectOuterPending)
        xmap ih <Plug>(GitGutterTextObjectInnerVisual)
        xmap ah <Plug>(GitGutterTextObjectOuterVisual)
        let g:gitgutter_sign_added = '+'
        let g:gitgutter_sign_modified = '~'
        if has('nvim-0.4.0')
            let g:gitgutter_highlight_linenrs = 1
        endif
    endif

    if !has('nvim-0.9.0')
        PackAdd! gen_tags.vim

        " gen_tags.vim
        let g:gen_tags#ctags_auto_update = 0
        let g:gen_tags#gtags_auto_update = 0
        let g:gen_tags#ctags_opts = '--links=no'
        let g:gen_tags#gtags_opts = '--skip-symlink'
        if !executable('gtags')
            let g:loaded_gentags#gtags = 1
        endif
        if !executable('ctags')
            let g:loaded_gentags#ctags = 1
        endif
    endif

    call s:auto_pair()
    if g:my_cmp_source ==? 'coc'
        call s:coc()
    endif
endfunction

function! s:auto_pair() abort
    if g:my_autopair ==? 'delimitmate'
        PackAdd! delimitmate
        "" see help delimitMateExpansion
        let g:delimitMate_expand_cr = 2
        let g:delimitMate_expand_space = 1
        let g:delimitMate_balance_matchpairs = 1
        augroup delimitMateCustom
            autocmd!
            autocmd FileType html,xhtml,xml let b:delimitMate_matchpairs = "(:),[:],{:}"
            autocmd FileType rust let b:delimitMate_quotes = "\" `"
        augroup END
    elseif g:my_autopair ==? 'lexima'
        PackAdd! lexima.vim
    endif
endfunction

function! s:coc() abort
    PackAdd! coc.nvim
    PackAdd! coc-fzf
    PackAdd! coc-neco

   let g:coc_fzf_preview = 'up:80%'
endfunction
