---@diagnostic disable: unused-local
-- "-------------------------------------------------------------------------------------------------+
-- " Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
-- " ================================================================================================+
-- " map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
-- " nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
-- " map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
-- " imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
-- " cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
-- " vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
-- " xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
-- " smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
-- " omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
-- " tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
-- " lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
-- "-------------------------------------------------------------------------------------------------+
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local silent = { silent = true }
local noremap = { noremap = true }
vim.g.mapleader = " "

keymap({ "n", "x" }, "<Leader>", "<Nop>", opts)

-- expand file
keymap("c", "<C-x>", "<C-r>=expand('%:p')<CR>")
-- expand path
keymap("c", "<C-z>", "<C-r>=expand('%:p:r')<CR>")

keymap("n", "<Leader>ls", ":<C-u>ls<CR>", noremap)
keymap("n", "<Leader>w", ":<C-u>w<CR>", opts)
keymap("n", "<Leader>bn", ":<C-u>bn<CR>", opts)
keymap("n", "<Leader>bp", ":<C-u>bp<CR>", opts)
keymap("n", "<Leader>bd", ":<C-u>bd<CR>", opts)
keymap("n", "<Leader>cd", ":<C-u>cd %:p:h<CR>", opts)

keymap("t", "<ESC>", [[<C-\><C-n>]], opts)

keymap("n", "<Plug>(lsp);", "<Nop>", opts)
keymap("n", ";", "<Plug>(lsp);")

keymap("n", "Z", "<Nop>", opts)
keymap("n", "[telescope]", "<Nop>", opts)
vim.api.nvim_set_keymap("n", "Z", "[telescope]", {})

keymap("n", "c2", 'ci"', opts)
keymap("n", "c7", "ci'", opts)
keymap("n", "c8", "ci(", opts)

keymap("n", "ca2", 'ca"', opts)
keymap("n", "ca7", "ca'", opts)
keymap("n", "ca7", "ca(", opts)

keymap("n", "v2", 'vi"', opts)
keymap("n", "v7", "vi'", opts)
keymap("n", "v8", "vi(", opts)

keymap("n", "va2", 'va"', opts)
keymap("n", "va7", "va'", opts)
keymap("n", "va7", "va(", opts)

keymap("n", "<M-j>", "O<ESC>", opts)
keymap("n", "<C-j>", "o<ESC>", opts)

keymap("n", "q:", ":q<CR>", opts)
keymap("n", "qq:", "qq:", opts)
