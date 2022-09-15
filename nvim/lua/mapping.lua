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

keymap({ "n", "x" }, "<Leader>", "<Nop>", opts)

-- expand file
keymap("c", "<C-x>", "<C-r>=expand('%:p')<CR>")
-- expand path
keymap("c", "<C-z>", "<C-r>=expand('%:p:r')<CR>")

keymap("n", "<Leader>ls", ":<C-u>ls<CR>", noremap)
keymap("n", "<Leader>w", ":<C-u>w<CR>", noremap)
keymap("n", "<Leader>bn", ":<C-u>bn<CR>", noremap)
keymap("n", "<Leader>bp", ":<C-u>bp<CR>", noremap)
keymap("n", "<Leader>bd", ":<C-u>bd<CR>", noremap)
keymap("n", "<Leader>cd", ":<C-u>cd %:p:h<CR>", opts)

keymap("t", "<ESC>", [[<C-\><C-n>]], opts)

keymap("n", "<Plug>(lsp);", "<Nop>", opts)
keymap("n", ";", "<Plug>(lsp);")

keymap("n", "Z", "<Nop>", opts)
keymap("n", "[telescope]", "<Nop>", opts)
vim.api.nvim_set_keymap("n", "Z", "[telescope]", {})

keymap("n", "v2", 'vi"', opts)
keymap("n", "v7", "vi'", opts)
keymap("n", "v8", "vi(", opts)

keymap("n", "va2", 'va"', opts)
keymap("n", "va7", "va'", opts)
keymap("n", "va7", "va(", opts)

keymap("n", "q", [[<Nop>]], opts)
keymap("n", "Q", [[q]], opts)
--keymap("n", "qh", [[<Cmd>call <SID>Quit('h')<CR>]], silent)
--keymap("n", "qj", [[<Cmd>call <SID>Quit('j')<CR>]], silent)
--keymap("n", "qk", [[<Cmd>call <SID>Quit('k')<CR>]], silent)
--keymap("n", "ql", [[<Cmd>call <SID>Quit('l')<CR>]], silent)
--keymap("n", "qq", [[<Cmd>call <SID>Quit()<CR>]], silent)
keymap("n", "q:", [[q:]], opts)
keymap("n", "q/", [[q/]], opts)
keymap("n", "q?", [[q?]], opts)


-- keymap("n", "p", "]p", silent)
-- keymap("n", "P", "]P", silent)
-- keymap("n", "]p", "p", silent)
-- keymap("n", "]P", "P", silent)

keymap("n", "<C-j>", "O<ESC>", opts)
keymap("n", "<M-j>", "o<ESC>", opts)
