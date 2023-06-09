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
vim.g.mapleader = " "

keymap("c", "<C-x>", "<C-r>=expand('%:p:h')<CR>")

keymap("n", "<Leader>q", ":q<CR>", opts)
keymap("n", "<Leader>w", ":w<CR>", opts)
keymap("n", "<Leader>bd", ":bd<CR>", opts)
keymap("n", "<Leader>bn", ":bn<CR>", opts)
keymap("n", "<Leader>bp", ":bp<CR>", opts)
keymap("n", "<Leader>cd", ":<C-u>cd %:p:h<CR>", opts)

keymap("n", "v2", 'vi"', opts)
keymap("n", "v7", "vi'", opts)
keymap("n", "v8", "vi(", opts)
keymap("n", "v[", "vi[", opts)
keymap("n", "v{", "vi{", opts)
keymap("n", "v@", "vi`", opts)

keymap("n", "va2", 'va"', opts)
keymap("n", "va7", "va'", opts)
keymap("n", "va8", "va(", opts)
keymap("n", "va[", "va[", opts)
keymap("n", "va{", "va{", opts)
keymap("n", "va@", "va`", opts)

keymap("o", "2", 'i"', opts)
keymap("o", "7", "i'", opts)
keymap("o", "8", "i(", opts)
keymap("o", "[", "i[", opts)
keymap("o", "{", "i{", opts)
keymap("o", "@", "i`", opts)

keymap("o", "a2", 'a"', opts)
keymap("o", "a7", "a'", opts)
keymap("o", "a8", "a(", opts)
keymap("o", "a[", "a[", opts)
keymap("o", "a{", "a{", opts)
keymap("o", "a@", "a`", opts)

keymap("t", "<esc>", [[<C-\><C-n>]], { noremap = true })
keymap({ 'n', 'o', 'x' }, '0', [[getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^']], { expr = true })
