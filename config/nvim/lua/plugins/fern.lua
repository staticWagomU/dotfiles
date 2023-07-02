return {
  "lambdalisue/fern.vim",
  lazy = false,
  dependencies = {
    "vim-denops/denops.vim",
    "lambdalisue/fern-git-status.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/nerdfont.vim",
    "yuki-yano/fern-preview.vim",
  },
  config = function()
    vim.cmd([[
      let g:fern#default_hidden=1
      let g:fern#renderer = "nerdfont"
      let g:fern#renderer#nerdfont#indent_markers = 1

      nnoremap <silent> <Leader>f :<C-u>Fern . <CR>
      nnoremap <silent> <Leader>F :<C-u>Fern %:h<CR>
      nnoremap <silent> <C-f> :Fern . -reveal=%<CR>

      function! s:fern_settings() abort
        nmap <silent> <buffer> <C-m> <Plug>(fern-action-move)
        nmap <silent> <buffer> <C-s> <Plug>(fern-action-new-dir)
        " nnoremap <buffer> <C-f> <C-W>p
        nmap <silent> <buffer> <Leader>cd <Plug>(fern-action-cd:cursor)
        nmap <silent> <buffer> p     <Plug>(fern-action-preview:auto:toggle)
        nmap <silent> <buffer> <C-n> <Plug>(fern-action-preview:scroll:down:half)
        nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:scroll:up:half)
        setlocal signcolumn=no
        setlocal nonumber
      endfunction

      augroup fern-settings
        autocmd!
        autocmd FileType fern call s:fern_settings()
      augroup END
      ]])
  end
}
