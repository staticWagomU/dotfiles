" hook_add {{{
function! s:ddu_grep() abort
    if system('git rev-parse --is-inside-work-tree') == "true\n"
        let l:cmd = 'git'
        let l:args = ['--no-pager', 'grep', '--line-number', '--column', '--no-color']
    else
        let l:cmd = 'rg'
        let l:args = ["--column", "--no-heading", "--color", "never"]
    endif

    let l:in = input('Pattern: ')

    if l:in == ''
        return
    endif
    call ddu#start(#{
                \ sources: ['rg'],
                \ sourceParams: #{
                \   rg: #{
                \     cmd: l:cmd,
                \     args: l:args,
                \     input: l:in,
                \   },
                \ },
                \ })
endfunction
nnoremap \g <Cmd>call <SID>ddu_grep()<Cr>
nnoremap \f <Cmd>call ddu#start(#{name:'file_recursive'})<Cr>
nnoremap \m <Cmd>Ddu mr<Cr>
nnoremap \d <Cmd>Ddu dpp<Cr>
nnoremap \l <Cmd>Ddu line<Cr>
" }}}

" hook_source {{{
call ddu#custom#load_config(expand('~/dotfiles/config/nvim/rc/ddu.ts'))
" }}}
