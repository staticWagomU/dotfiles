"{{{options
if has('vim_starting')
  set encoding=utf-8
  set fileencodings=iso-2022-jp,ucs-bom,sjis,utf-8,euc-jp,cp932,default,latin1
  set fileformats=unix,dos,mac
endif
scriptencoding utf-8

if &compatible
  set nocompatible
endif


let s:enable_coc = v:false
let s:enable_ddc = v:false
let s:enable_lsp = v:false
let s:enable_nvim_cmp = v:true
filetype off
filetype plugin indent off


set number
set helplang=ja
set signcolumn=yes 
set hidden
set laststatus=2
set mouse=a
set clipboard=unnamedplus
set title
let &g:titlestring =
      \ "%{expand('%:p:~:.')} %<\(%{fnamemodify(getcwd(), ':~')}\)%(%m%r%w%)"
"}}}

"{{{ plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-jp/vimdoc-ja'

Plug 'mattn/emmet-vim'
Plug 'hrsh7th/vim-searchx'
Plug 'vim-denops/denops.vim'
Plug 'simeji/winresizer'
Plug 'cohama/lexima.vim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mattn/vim-goimports'
Plug 'mattn/vim-sonictemplate'
Plug 'machakann/vim-sandwich'
Plug 'skanehira/translate.vim'

"{{{ startup menu
Plug 'mhinz/vim-startify'
"}}}

"{{{ coc
if s:enable_coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
"}}}

if s:enable_nvim_cmp
"{{{ nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-cmdline'
Plug 'f3fora/cmp-spell'
Plug 'yutkat/cmp-mocword'
Plug 'nvim-lua/plenary.nvim'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'onsails/lspkind.nvim'
Plug 'petertriho/cmp-git'
"}}}
endif

" {{{ git
Plug 'lambdalisue/gin.vim'
Plug 'airblade/vim-gitgutter'
" }}}

" {{{ fern
Plug 'lambdalisue/fern.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/fern-git-status.vim'
" }}}

" {{{ colorscheme
Plug 'arcticicestudio/nord-vim'
" }}}

if s:enable_lsp
" {{{ lsp
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'mattn/vim-lsp-settings'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
"}}}
endif

if s:enable_ddc
" {{{ ddc
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-around' " sources
Plug 'Shougo/ddc-matcher_head' " filters
Plug 'Shougo/ddc-sorter_rank' " filters
Plug 'Shougo/ddc-nvim-lsp'
Plug 'Shougo/ddc-converter_remove_overlap'
" }}}
endif

call plug#end()
"}}}

"{{{ keymaps

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

let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

nmap s <Nop>
xmap s <Nop>

inoremap <silent> jj <ESC>


" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>\
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

nnoremap <Leader>ls :<C-u>ls<CR>
nnoremap <Leader>w :<C-u>w<CR>
nnoremap <Leader>bn :<C-u>bn<CR>
nnoremap <Leader>bp :<C-u>bp<CR>
nnoremap <Leader>bd :<C-u>bd<CR>
"}}}

"{{{ pluginConfig

if s:enable_nvim_cmp
"{{{nvim-cmp
lua <<EOF
local lspkind = require'lspkind'
local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		--completion = cmp.config.window.bordered(),
		--documentation = cmp.config.window.bordered(),
	},
	formatting = {
		--fields = {'kind', 'addr', 'menu'},
		format = lspkind.cmp_format({
			mode = 'symbol_text',
			maxwidth = 50,
			with_text = false,
		})

	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), 
		-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp_signature_help' },
	}, {
		{ name = 'path' },
	}, {
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'calc' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

require('cmp_git').setup({})

cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'nvim_lsp_document_symbol' },
		{ name = 'buffer' },
	},
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})


local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_init = function(client)
	client.config.flags = {}
	if client.config.flags then
		client.config.flags.allow_incremental_sync = true
		client.config.flags.debounce_text_changes = 200
	end
end
require'lspconfig'.gopls.setup {
	capabilities = capabilities,
	on_init = on_init;
	init_options = {
		gofumpt = true,
		usePlaceholders = true,
		semanticTokens = true,
		staticcheck = true,
		experimentalPostfixCompletions = true,
		hoverKind = 'Structured',
		analyses = {
			nilness = true,
			shadow = true,
			unusedparams = true,
			unusedwrite = true,
			fieldalignment = true
		},
			codelenses = {
			gc_details = true,
			tidy = true
		}
	}
}

require'lspconfig'.vimls.setup {
	on_init = on_init;
	capabilities = capabilities,
}

--require'lspconfig'.tsserver.setup {
--	on_init = on_init;
--	capabilities = capabilities,
--	on_attach = function(client)
--		client.resolved_capabilities.documentFormattingProvider = false
--	end,
--}

require'lspconfig'.denols.setup {
	on_init = on_init;
	capabilities = capabilities,
	init_options = {
		suggest = {
			autoImports = true,
			completeFunctionCalls = true,
			names = true,
			paths = true,
			imports = {
				autoDiscover = false,
				hosts = {
					['https://deno.land/'] = true,
				},
			},
		},
	}
}
EOF
nnoremap <silent> gf<CR>       <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gfv          <Cmd>vsplit<CR><Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gfs          <Cmd>split<CR><Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>i    <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>g    <Cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>f    <Cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <Leader>r    <Cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <Leader><CR> <Cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <C-k>        <Cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-j>        <Cmd>lua vim.diagnostic.goto_next()<CR>
"}}}
endif

if s:enable_ddc
"{{{ ddc
call ddc#custom#patch_global('sources', ['around', 'nvim-lsp'])

call ddc#custom#patch_global('sourceoptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank'],
      \   'converters': ['converter_remove_overlap'],},
      \ 'around': {'mark': 'Around'},
      \ 'nvim-lsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ })

call ddc#custom#patch_global('sourceparams', {
     \ 'around': {'maxsize': 500},
     \ 'nvim-lsp': {'kindLabels': {'Class': 'c'}}
     \ })

inoremap <silent><expr> <TAB>
\ ddc#map#pum_visible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

call ddc#enable()
"}}}
endif

if s:enable_coc
"{{{ coc
nnoremap [dev]    <Nop>
xnoremap [dev]    <Nop>
nmap     m        [dev]
xmap     m        [dev]

let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint8', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists']

inoremap <silent> <expr> <c-space> coc#refresh()
nnoremap <silent> K       :<c-u>call <sid>show_documentation()<cr>
nmap     <silent> [dev]rn <plug>(coc-rename)
nmap     <silent> [dev]a  <plug>(coc-codeaction-selected)iw

function! s:coc_typescript_settings() abort
  nnoremap <silent> <buffer> [dev]f :<c-u>coccommand eslint.executeautofix<cr>:coccommand prettier.formatfile<cr>
endfunction

augroup coc_ts
  autocmd!
  autocmd filetype typescript,typescriptreact call <sid>coc_typescript_settings()
augroup end

function! s:show_documentation() abort
  if index(['vim','help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  elseif coc#rpc#ready()
    call cocactionasync('dohover')
  endif
endfunction
"}}}
endif

if s:enable_lsp
" {{{ lsp-config
lua << EOF
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
--vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = {'tsserver' }
--for _, lsp in pairs(servers) do
--  require('lspconfig')[lsp].setup {
--    on_attach = on_attach,
--    flags = {
--      -- This will be the default in neovim 0.7+
--      debounce_text_changes = 150,
--    }
--  }
--end
--local lspconfig = require "lspconfig"
--local util = require "lspconfig/util"
--
--lspconfig.gopls.setup {
--  cmd = {"gopls", "serve"},
--  filetypes = {"go", "gomod"},
--  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
--  settings = {
--    gopls = {
--      analyses = {
--        unusedparams = true,
--      },
--      staticcheck = true,
--      --debounce_text_changes = 150,
--    },
--  },
--}
EOF
" }}}
endif

if s:enable_lsp
"{{{ lsp
if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1 
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
"}}}
endif

" {{{ lualine
lua << EOF
require('lualine').setup {}
EOF
"}}}

"{{{ jumpcursor
nmap [j <Plug>(jumpcursor-jump)
"}}}

"{{{ fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer <CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -toggle<CR>
let g:fern#default_hidden=1

function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
  nmap <silent> <buffer> <C-m> <Plug>(fern-action-move)
  nmap <silent> <buffer> <C-S-d> <Plug>(fern-action-new-dir)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END



"{{{ fern-git-status
" Disable listing ignored files/directories
let g:fern_git_status#disable_ignored = 1
" Disable listing untracked files
let g:fern_git_status#disable_untracked = 1
" Disable listing status of submodules
let g:fern_git_status#disable_submodules = 1
" Disable listing status of directories
let g:fern_git_status#disable_directories = 1
"}}}

"}}}

"{{{ vim-searchx
" Overwrite / and ?.
nnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
nnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
xnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
xnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
cnoremap ; <Cmd>call searchx#select()<CR>

" Move to next/prev match.
nnoremap N <Cmd>call searchx#prev_dir()<CR>
nnoremap n <Cmd>call searchx#next_dir()<CR>
xnoremap N <Cmd>call searchx#prev_dir()<CR>
xnoremap n <Cmd>call searchx#next_dir()<CR>
nnoremap <C-k> <Cmd>call searchx#prev()<CR>
nnoremap <C-j> <Cmd>call searchx#next()<CR>
xnoremap <C-k> <Cmd>call searchx#prev()<CR>
xnoremap <C-j> <Cmd>call searchx#next()<CR>
cnoremap <C-k> <Cmd>call searchx#prev()<CR>
cnoremap <C-j> <Cmd>call searchx#next()<CR>
"}}}

" {{{ treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  }
}
EOF
" }}}

" {{{ startify
let g:ascii = [
    \ ' __    __   ____   ____   ___   ___ ___  __ __ ',
    \ '|  |__|  | /    | /    | /   \ |   |   ||  |  |',
    \ '|  |  |  ||  o  ||   __||     || _   _ ||  |  |',
    \ '|  |  |  ||     ||  |  ||  O  ||  \_/  ||  |  |',
    \ '|  `  ''  ||  _  ||  |_ ||     ||   |   ||  :  |',
    \ ' \      / |  |  ||     ||     ||   |   ||     |',
    \ '  \_/\_/  |__|__||___,_| \___/ |___|___| \__,_|',
    \ '']                                               


let g:startify_custom_header = g:ascii

let g:startify_lists = [
    \ { 'header': ['   MRU'],            'type': 'files' },
    \ { 'header': ['   Sessions'],       'type': 'sessions' },
    \ ]

function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction

let g:startify_bookmarks = ["~/dotfiles/nvim/rc/init.vim", "~/dotfiles/nvim/rc/ginit.vim"]
autocmd User Startified setlocal cursorline
let g:startify_skiplist = [
   \ '.*\.jax$',
   \ ]
" }}}

" {{{ translate.vim
let g:translate_source = "en"
let g:translate_target = "ja"
vmap t <Plug>(VTranslate)
" }}}

" {{{ git-gutter
" By default updatetime is 4000 ms
set updatetime=100

" Use fontawesome icons as signs
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

" Default key mapping off
let g:gitgutter_map_keys = 0
" }}}

"}}}

" {{{ autocmd
augroup restore-cursor
  autocmd!
  autocmd BufReadPost *
        \ : if line("'\"") >= 1 && line("'\"") <= line("$")
        \ |   exe "normal! g`\""
        \ | endif
  autocmd BufWinEnter *
  
        \ : if empty(&buftype) && line('.') > winheight(0) / 2
        \ |   execute 'normal! zz'
        \ | endif
augroup END

autocmd TermOpen * startinsert

autocmd FileType vim setlocal foldmethod=marker
"}}}

" {{{ other
cd ~
colorscheme nord
filetype plugin indent on
set winblend=10
" }}}
