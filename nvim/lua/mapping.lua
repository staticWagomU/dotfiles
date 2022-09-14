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
local silent = { noremap = true, silent = true }

keymap({ "n", "x" }, "<Leader>", "<Nop>", silent)

-- expand file
keymap("c", "<C-x>", "<C-r>=expand('%:p')<CR>", {})
-- expand path
keymap("c", "<C-z>", "<C-r>=expand('%:p:r')<CR>", {})

keymap("n", "<Leader>ls", ":<C-u>ls<CR>", { noremap = true })
keymap("n", "<Leader>w", ":<C-u>w<CR>", { noremap = true })
keymap("n", "<Leader>bn", ":<C-u>bn<CR>", { noremap = true })
keymap("n", "<Leader>bp", ":<C-u>bp<CR>", { noremap = true })
keymap("n", "<Leader>bd", ":<C-u>bd<CR>", { noremap = true })
keymap("n", "<Leader>cd", ":<C-u>cd %:p:h<CR>", silent)

keymap("t", "<ESC>", [[<C-\><C-n>]], silent)

keymap("n", ";", "<Nop>", silent)
keymap("n", "[lsp]", "<Nop>", silent)
keymap("n", ";", "[lsp]", {})

keymap("n", "Z", "<Nop>", silent)
keymap("n", "[telescope]", "<Nop>", silent)
keymap("n", "Z", "[telescope]", {})

keymap("n", "v2", 'vi"', silent)
keymap("n", "v7", "vi'", silent)
keymap("n", "v8", "vi(", silent)

keymap("n", "va2", 'va"', silent)
keymap("n", "va7", "va'", silent)
keymap("n", "va7", "va(", silent)

keymap("n", "q", [[<Nop>]], silent)
keymap("n", "Q", [[q]], silent)
--keymap("n", "qh", [[<Cmd>call <SID>Quit('h')<CR>]], silent)
--keymap("n", "qj", [[<Cmd>call <SID>Quit('j')<CR>]], silent)
--keymap("n", "qk", [[<Cmd>call <SID>Quit('k')<CR>]], silent)
--keymap("n", "ql", [[<Cmd>call <SID>Quit('l')<CR>]], silent)
--keymap("n", "qq", [[<Cmd>call <SID>Quit()<CR>]], silent)
keymap("n", "q:", [[q:]], silent)
keymap("n", "q/", [[q/]], silent)
keymap("n", "q?", [[q?]], silent)


-- keymap("n", "p", "]p", silent)
-- keymap("n", "P", "]P", silent)
-- keymap("n", "]p", "p", silent)
-- keymap("n", "]P", "P", silent)

keymap("n", "<C-j>", "O<ESC>", silent)
keymap("n", "<M-j>", "o<ESC>", silent)
