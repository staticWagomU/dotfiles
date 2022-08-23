vim.cmd[[
let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

nmap s <Nop>
xmap s <Nop>

"inoremap <silent> jj <ESC>


" expand path
cmap <C-x> <C-r>=expand('%:p')<CR>
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

nnoremap <Leader>ls :<C-u>ls<CR>
nnoremap <Leader>w :<C-u>w<CR>
nnoremap <Leader>bn :<C-u>bn<CR>
nnoremap <Leader>bp :<C-u>bp<CR>
nnoremap <Leader>bd :<C-u>bd<CR>
nnoremap <silent> <Leader>cd :<C-u>cd %:p:h<CR>
nnoremap <C-^> :<C-u>so $MYVIMRC<CR>

tnoremap <ESC> <C-\><C-n>
tnoremap <C-w><C-l> <C-\><C-n><C-w><C-l>
tnoremap <C-w><C-h> <C-\><C-n><C-w><C-h>

]]

vim.api.nvim_set_keymap("n", ";", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[lsp]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", ";", "[lsp]", {})

vim.api.nvim_set_keymap("n", "Z", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[telescope]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "Z", "[telescope]", {})

vim.api.nvim_set_keymap("v", "Z", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "[telescope]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "Z", "[telescope]", {})