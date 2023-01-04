vim.cmd([[
let g:netrw_keepdir = 0 " tree開いた位置を current dir として扱う。その階層でファイル作成とかができるようになる
let g:netrw_banner = 0 " 上のバナー消す
 let g:netrw_winsize = 35 "window サイズ
let g:netrw_liststyle=1 " ファイルツリーの表示形式、1にするとls -laのような表示になります
let g:netrw_sizestyle="H" " サイズを(K,M,G)で表示する
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S" " フォーマットを yyyy/mm/dd(曜日) hh:mm:ss 
let g:netrw_preview=1 " プレビューウィンドウを垂直分割で表示する
"Netrw を toggle する関数を設定
"元処理と異なり Vex を呼び出すことで左 window に表示
"noremap <silent><C-e> :e ./<CR>
]])
