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
set.backspace = {"indent", "eol", "start"}

vim.cmd [=[
set directory=~
set backupdir=~
set undodir=~
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
autocmd bufWritePost * :lua vim.lsp.buf.format()

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
]=]
