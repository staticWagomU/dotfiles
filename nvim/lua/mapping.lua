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
local m = vim.api.nvim_set_keymap
local silent = { noremap = true, silent = true }

m("n", "<Leader>", "<Nop>", silent)
m("x", "<Leader>", "<Nop>", silent)

-- expand file
m("c", "<C-x>", "<C-r>=expand('%:p')<CR>", {})
-- expand path
m("c", "<C-z>", "<C-r>=expand('%:p:r')<CR>", {})

m("n", "<Leader>ls", ":<C-u>ls<CR>", { noremap = true })
m("n", "<Leader>w", ":<C-u>w<CR>", { noremap = true })
m("n", "<Leader>bn", ":<C-u>bn<CR>", { noremap = true })
m("n", "<Leader>bp", ":<C-u>bp<CR>", { noremap = true })
m("n", "<Leader>bd", ":<C-u>bd<CR>", { noremap = true })
m("n", "<Leader>cd", ":<C-u>cd %:p:h<CR>", silent)

m("t", "<ESC>", "<C-\\><C-n>", silent)
m("t", "<C-w><C-l>", "<C-\\><C-n><C-w><C-l>", silent)
m("t", "<C-w><C-h>", "<C-\\><C-n><C-w><C-h>", silent)

m("n", ";", "<Nop>", silent)
m("n", "[lsp]", "<Nop>", silent)
m("n", ";", "[lsp]", {})

m("n", "Z", "<Nop>", silent)
m("n", "[telescope]", "<Nop>", silent)
m("n", "Z", "[telescope]", {})

m("v", "Z", "<Nop>", silent)
m("v", "[telescope]", "<Nop>", silent)
m("v", "Z", "[telescope]", {})

m("n", "v2", 'vi"', silent)
m("n", "v7", "vi'", silent)
m("n", "v8", "vi(", silent)

m("n", "a2", 'ai"', silent)
m("n", "a7", "ai'", silent)
m("n", "a8", "ai(", silent)

m("n", "q", [[<Nop>]], silent)
m("n", "Q", [[q]], silent)
--m("n", "qh", [[<Cmd>call <SID>Quit('h')<CR>]], silent)
--m("n", "qj", [[<Cmd>call <SID>Quit('j')<CR>]], silent)
--m("n", "qk", [[<Cmd>call <SID>Quit('k')<CR>]], silent)
--m("n", "ql", [[<Cmd>call <SID>Quit('l')<CR>]], silent)
--m("n", "qq", [[<Cmd>call <SID>Quit()<CR>]], silent)
m("n", "q:", [[q:]], silent)
m("n", "q/", [[q/]], silent)
m("n", "q?", [[q?]], silent)
