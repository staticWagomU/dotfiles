vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.cmd [[
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_filetype_exclude = ['alpha']
]]

require("indent_blankline").setup {
show_end_of_line = true,
space_char_blankline = " ",
}
