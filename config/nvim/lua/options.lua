<<<<<<< HEAD
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings= 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
||||||| 1350751
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
vim.g.loaded_netrw             = 0
vim.g.loaded_netrwPlugin       = 0
vim.g.loaded_netrwSettings     = 0
vim.g.loaded_netrwFileHandlers = 0
vim.o.foldcolumn               = '0'
vim.o.foldlevel                = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart           = 99
vim.o.foldenable               = true
vim.o.shiftwidth               = 2
vim.o.tabstop                  = 2
vim.o.softtabstop              = 2
vim.g.mapleader                = " "
=======
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings= 1
vim.g.loaded_netrwFileHandlers = 1
>>>>>>> 60061f5604134080658d72f3c54044da718f135e

<<<<<<< HEAD
||||||| 1350751
local set                      = vim.opt
=======
vim.g.mapleader = " "
>>>>>>> 60061f5604134080658d72f3c54044da718f135e

<<<<<<< HEAD
local set = vim.opt
set.ambiwidth = "single"
set.backspace = { "indent", "eol", "start" }
set.backupdir = vim.fn.expand("~")
set.clipboard = "unnamedplus"
set.directory = vim.fn.expand("~")
set.display = "uhex"
set.expandtab = true
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
||||||| 1350751
set.number                     = false
set.relativenumber             = false
set.wrap                       = false
set.helplang                   = "ja"
set.signcolumn                 = "yes"
set.hidden                     = true
set.laststatus                 = 3
set.mouse                      = "a"
set.clipboard                  = "unnamedplus"
set.ambiwidth                  = "single"
set.ignorecase                 = true
set.smartcase                  = true
set.splitbelow                 = true
set.splitright                 = true
set.display                    = "uhex"
set.wildmenu                   = true
set.expandtab                  = true
set.wrapscan                   = true
set.termguicolors              = true
set.showmode                   = false
set.list                       = true
set.listchars                  = { eol = '↴', tab = '▸ ', trail = '»', space = '⋅' }
set.fillchars                  = {
  stl = '━',
  -- stl = ' ',
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
set.backspace                  = { "indent", "eol", "start" }
---@diagnostic disable-next-line: assign-type-mismatch
set.directory                  = vim.fn.expand("~")
---@diagnostic disable-next-line: assign-type-mismatch
set.backupdir                  = vim.fn.expand("~")
---@diagnostic disable-next-line: assign-type-mismatch
set.undodir                    = vim.fn.expand("~")
set.laststatus                 = 3
set.fileformat                 = "unix"
=======
vim.opt.compatible = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.helplang = "ja"
vim.opt.signcolumn = "yes"
vim.opt.hidden = true
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus", "autoselect"
>>>>>>> 60061f5604134080658d72f3c54044da718f135e

<<<<<<< HEAD
vim.cmd [=[
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

vim.api.nvim_create_user_command("ShowPluginReadme", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  local plugin_name = string.match(vim.fn.expand("<cWORD>"), "['\"].*/(.*)['\"]")
  local path = vim.fn.stdpath("data") .. "/site/pack/packer/*/" .. plugin_name .. "/README.md"

  vim.cmd("edit " .. vim.fn.resolve(path))
end, { force = true })

vim.filetype.add({
  extension = {
    mdx = 'markdown',
  },
})

vim.api.nvim_create_augroup("extra-whitespace", {})
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  group = "extra-whitespace",
  pattern = { "*" },
  desc = "全角空白を可視化させる",
  command = [[call matchadd("ExtraWhitespace", "[\u00A0\u2000-\u200B\u3000]")]]
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = "extra-whitespace",
  pattern = { "*" },
  desc = "全角空白を可視化させる",
  command = [[highlight default ExtraWhitespace ctermbg=red guibg=red]]
})
||||||| 1350751
vim.cmd [=[
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

vim.api.nvim_create_user_command("ShowPluginReadme", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  local plugin_name = string.match(vim.fn.expand("<cWORD>"), "['\"].*/(.*)['\"]")
  local path = vim.fn.stdpath("data") .. "/site/pack/packer/*/" .. plugin_name .. "/README.md"

  vim.cmd("edit " .. vim.fn.resolve(path))
end, { force = true })

vim.filetype.add({
  extension = {
    mdx = 'markdown',
  },
})

-- vim.api.nvim_create_autocmd("InsertEnter", {
--   pattern = "*",
--   desc = "インサート時に検索ハイライトを消す",
--   callback = function()
--     vim.schedule(vim.cmd.nohlsearch)
--   end
-- })

vim.api.nvim_create_augroup("extra-whitespace", {})
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  group = "extra-whitespace",
  pattern = { "*" },
  desc = "全角空白を可視化させる",
  command = [[call matchadd("ExtraWhitespace", "[\u00A0\u2000-\u200B\u3000]")]]
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = "extra-whitespace",
  pattern = { "*" },
  desc = "全角空白を可視化させる",
  command = [[highlight default ExtraWhitespace ctermbg=red guibg=red]]
})
local lsplns = vim.api.nvim_create_augroup("toggleLspLines", {})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = lsplns,
  pattern = { "*" },
  callback = function()
    vim.diagnostic.config({ virtual_lines = false })
  end
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = lsplns,
  pattern = { "*" },
  callback = function()
    vim.diagnostic.config({ virtual_lines = true })
  end
})
=======
>>>>>>> 60061f5604134080658d72f3c54044da718f135e
