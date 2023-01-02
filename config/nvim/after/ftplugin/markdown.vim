" 参考:https://zenn.dev/kawarimidoll/articles/8abb570dac523f 
function! s:sort_qf(a, b) abort
  return a:a.lnum > a:b.lnum ? 1 : -1
endfunction

function! s:markdown_outline() abort
  let fname = @%
  let current_win_id = win_getid()

  " # heading
  execute 'vimgrep /^#\{1,6} .*$/j' fname

  " heading
  " ===
  execute 'vimgrepadd /\zs\S\+\ze\n[=-]\+$/j' fname

  let qflist = getqflist()
  if len(qflist) == 0
    cclose
    return
  endif

  " make sure to focus original window because synID works only in current window
  call win_gotoid(current_win_id)
  call filter(qflist,
        \ 'synIDattr(synID(v:val.lnum, v:val.col, 1), "name") != "markdownCodeBlock"'
        \ )
  call sort(qflist, funcref('s:sort_qf'))
  call setqflist(qflist)
  call setqflist([], 'r', {'title': fname .. ' TOC'})
  copen
endfunction

nnoremap <buffer> gO <Cmd>call <sid>markdown_outline()<CR>a

