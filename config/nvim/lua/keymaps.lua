--[=[
"-------------------------------------------------------------------------------------------------+
" Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
" ================================================================================================+
" map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
" nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
" map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
" imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
" cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
" vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
" xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
" smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
" omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
" tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
" lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
"-------------------------------------------------------------------------------------------------+
-- ]=]
local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

keymap({ 'n' }, '<Space>', '<Nop>', opts)
keymap({ 'n' }, 's', '<Nop>', opts)

keymap({ 'n' }, '<Leader>w', '<Cmd>w<Cr>', opts)

keymap({ 'n' }, '<Leader>bn', '<Cmd>bnext<Cr>', opts)
keymap({ 'n' }, '<Leader>bp', '<Cmd>bprevious<Cr>', opts)
keymap({ 'n' }, '<Leader>bd', '<Cmd>bdelete<Cr>', opts)
keymap({ 'n' }, '<Leader>bc', '<Cmd>close<Cr>', opts)
keymap({ 'n' }, '<Leader>cd', '<Cmd>cd %:p:h<Cr>', opts)

keymap({ 'n' }, 'i', [[len(getline('.')) ? 'i' : '"_cc']], { expr = true })
keymap({ 'n' }, 'A', [[len(getline('.')) ? 'A' : '"_cc']], { expr = true })

keymap({ 'n' }, 'v2', 'vi"', opts)
keymap({ 'n' }, 'v7', "vi'", opts)
keymap({ 'n' }, 'v8', 'vi(', opts)
keymap({ 'n' }, 'v[', 'vi[', opts)
keymap({ 'n' }, 'v{', 'vi{', opts)
keymap({ 'n' }, 'v@', 'vi`', opts)

keymap({ 'n' }, 'va2', 'va"', opts)
keymap({ 'n' }, 'va7', "va'", opts)
keymap({ 'n' }, 'va8', 'va(', opts)
keymap({ 'n' }, 'va[', 'va[', opts)
keymap({ 'n' }, 'va{', 'va{', opts)
keymap({ 'n' }, 'va@', 'va`', opts)

keymap({ 'o' }, '2', 'i"', opts)
keymap({ 'o' }, '7', "i'", opts)
keymap({ 'o' }, '8', 'i(', opts)
keymap({ 'o' }, '[', 'i[', opts)
keymap({ 'o' }, '{', 'i{', opts)
keymap({ 'o' }, '@', 'i`', opts)

keymap({ 'o' }, 'a2', 'a"', opts)
keymap({ 'o' }, 'a7', "a'", opts)
keymap({ 'o' }, 'a8', 'a(', opts)
keymap({ 'o' }, 'a[', 'a[', opts)
keymap({ 'o' }, 'a{', 'a{', opts)
keymap({ 'o' }, 'a@', 'a`', opts)

keymap({ 't' }, '<esc>', [[<C-\><C-n>]], { noremap = true })
keymap({ 'n', 'o', 'x' }, '0', [[getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^']], { expr = true })
