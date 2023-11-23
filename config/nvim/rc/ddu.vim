" hook_add {{{
nnoremap sf <Cmd>call ddu#start(#{name:'file_recursive'})<Cr>
" }}}

" hook_source {{{
call ddu#custom#load_config(expand('~/dotfiles/config/nvim/rc/ddu.ts'))
" }}}
