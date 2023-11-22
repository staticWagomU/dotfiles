vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.mapleader = " "

local set = vim.opt
set.ambiwidth = "single"
set.backspace = { "indent", "eol", "start" }
set.clipboard = "unnamedplus"
set.backupdir = vim.fn.expand("~")
set.directory = vim.fn.expand("~")
set.expandtab = true
set.fileformat = "unix"
set.fillchars = {
	stl = '━',
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
set.helplang = "ja"
set.hidden = true
set.ignorecase = true
set.laststatus = 3
set.list = true
set.listchars = { eol = '↴', tab = '▸ ', trail = '»', space = '⋅' }
set.mouse = "a"
set.shiftwidth = 2
set.showcmd = false
set.showmode = false
set.signcolumn = "yes"
set.smartcase = true
set.smarttab = true
set.softtabstop = 2
set.splitbelow = true
set.splitright = true
set.swapfile = false
set.tabstop = 2
set.termguicolors = true
set.undodir = vim.fn.expand("~")
set.whichwrap = "b,s,h,l,<,>,[,]"
set.wildmenu = true
set.wrap = false
set.wrapscan = true

vim.cmd [=[
augroup restore-cursor
	autocmd!
	autocmd BufReadPost *
		\ : if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
		\ |   execute "normal! g`\""
		\ | endif

		\ : if empty(&buftype) && line('.') > winheight(0) / 2
		\ |   execute 'normal! zz'
		\ | endif
augroup END
]=]
