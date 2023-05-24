return {
  {
  "vim-skk/skkeleton",
  config = function()
   vim.cmd[=[
function! s:skkeleton_init() abort
	if has('mac')
		call skkeleton#config(#{
					\ eggLikeNewline: v:true,
					\ globalDictionaries: [
					\  ["~/skk/SKK-JISYO.L", "euc-jp"],
					\ ],
					\ registerConvertResult: v:true,
					\})
	endif
	if has('win32')
		call skkeleton#config(#{
					\ eggLikeNewline: v:true,
					\ globalDictionaries: [
					\  ["~\\skk\\SKK-JISYO.L", "euc-jp"],
					\ ],
					\ registerConvertResult: v:true,
					\})
	endif
	call skkeleton#register_kanatable('rom', {
				\ "z\<Space>": ["\u3000", ''],
				\})
endfunction

augroup skkeleton-initialize-pre
	autocmd!
	autocmd User skkeleton-initialize-pre call s:skkeleton_init()
augroup END


function! s:skkeleton_pre() abort
	" Overwrite sources
	let s:prev_buffer_config = ddc#custom#get_buffer()
	call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction
autocmd User skkeleton-enable-pre call s:skkeleton_pre()

function! s:skkeleton_post() abort
	" Restore sources
	call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction
autocmd User skkeleton-disable-pre call s:skkeleton_post()


imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
   ]=] 
  end
  },
  {
    "delphinus/skkeleton_indicator.nvim",
    depends = { "vim-skk/skkeleton" },
    opts = {
      alwaysShown = false,
    },
  },
}
