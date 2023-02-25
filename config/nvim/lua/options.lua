local vim                      = vim
vim.g.loaded_gzip              = 1
vim.g.loaded_tar               = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_zip               = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_vimball           = 1
vim.g.loaded_vimballPlugin     = 1
vim.g.loaded_getscript         = 1
vim.g.loaded_getscriptPlugin   = 1
-- vim.g.loaded_netrw             = 1
-- vim.g.loaded_netrwPlugin       = 1
-- vim.g.loaded_netrwSettings     = 1
-- vim.g.loaded_netrwFileHandlers = 1
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.mapleader = " "

local set = vim.opt

set.number = false
set.relativenumber = false
set.wrap = false
set.helplang = "ja"
set.signcolumn = "yes"
set.hidden = true
set.laststatus = 2
set.mouse = "a"
set.clipboard = "unnamedplus"
set.ambiwidth = "single"
set.ignorecase = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.display = "uhex"
set.wildmenu = true
set.expandtab = true
set.wrapscan = true
set.termguicolors = true
set.showmode = false
set.list = true
set.listchars = { eol = '↴', tab = '▸ ', trail = '»', space = '⋅' }
set.fillchars = {
  stl = ' ',
  stlnc = ' ',
  diff = '∙',
  eob = ' ',
  fold = '·',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋'
}
-- set.winbar = '%=%f%m%='
set.backspace = { "indent", "eol", "start" }

vim.cmd [=[
set directory=~
set backupdir=~
set undodir=~
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" autocmd bufWritePost * :lua vim.lsp.buf.format()

augroup restore-cursor
	autocmd!
	autocmd BufReadPost *
		\ : if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
		\ |   exe "normal! g`\""
		\ | endif

		\ : if empty(&buftype) && line('.') > winheight(0) / 2
		\ |   execute 'normal! zz'
		\ | endif
augroup END

"autocmd InsertEnter * lia vim.schedule(vim.cmd.nohlsearch)
]=]

vim.api.nvim_create_user_command("ShowPluginReadme", function()
	local plugin_name = string.match(vim.fn.expand("<cWORD>"), "['\"].*/(.*)['\"]")
	local path = vim.fn.stdpath("data") .. "/site/pack/packer/*/" .. plugin_name .. "/README.md"

	vim.cmd("edit " .. vim.fn.resolve(path))
end, { force = true })

vim.filetype.add({
  extension = {
    mdx = 'markdown',
  },
})
