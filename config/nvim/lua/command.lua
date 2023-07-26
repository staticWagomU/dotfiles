vim.api.nvim_create_user_command("Dot", function()
  require("utils").dumpTable(vim.api.nvim_get_keymap("n"))
end, { force = true })

vim.cmd[=[
function! s:zenn_create_article(article_name) abort
	let aname = a:article_name
	" slugは12文字以上、50文字以下
	" 先頭に日付(yyyymmdd)を加えるため、実質4文字以上、42文字以下
	if strlen(a:article_name) > 42
		let aname = a:article_name[0:42]
	endif
	if strlen(a:article_name) < 4
		let aname = a:article_name .. "___"
	endif
	echo "1:tech 2:idea"
	let a = getchar()
	let type = "tech"
	if a == 50
		let type = "idea"
	endif
	let date = strftime("%Y%m%d")
	let slug = date .. aname
	call system("deno run -A npm:zenn-cli@latest new:article --slug " .. slug .. " --type " .. type )
	execute "edit articles/" .. slug .. ".md"
endfunction

function! s:zenn_preview() abort
	execute "bo term deno run -A npm:zenn-cli@latest preview"
	execute "resize -100"
	execute "normal! \<c-w>\<c-w>"
	execute "sleep"
	execute "OpenBrowser localhost:8000"
endfunction

command! -nargs=1 ZennCreate call <sid>zenn_create_article(<f-args>)
command! ZennPreview call <sid>zenn_preview()
]=]
vim.api.nvim_create_user_command("PluginList", function()
  local plugins = require("lazy").plugins()
  for i, plugin in ipairs(plugins) do
    vim.fn.setline(i, plugin[1])
  end
end, {})
