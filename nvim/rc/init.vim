"{{{optionsz
if has('vim_starting')
        set encoding=utf-8
        set fileencodings=iso-2022-jp,ucs-bom,sjis,utf-8,euc-jp,cp932,default,latin1
        set fileformats=unix,dos,mac
endif
scriptencoding utf-8

if &compatible
set nocompatible
endif


let s:enable_ddc = v:false
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
set ambiwidth=single
set ignorecase
set smartcase
set splitbelow
set splitright
set display=uhex
set wildmenu
set expandtab
set wrapscan
set termguicolors
set noshowmode
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set title
let &g:titlestring =
	\ "%{expand('%:p:~:.')} %<\(%{fnamemodify(getcwd(), ':~')}\)%(%m%r%w%)"
"}}}

"{{{ plugin
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
Plug 'petertriho/nvim-scrollbar'
Plug 'numToStr/Comment.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'staticWagomu/wagomuColor'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'cocopon/iceberg.vim'
Plug 'skanehira/jumpcursor.vim'

"{{{telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'crispgm/telescope-heading.nvim'
Plug 'LinArcX/telescope-changes.nvim'
Plug 'nvim-telescope/telescope-rg.nvim'
Plug 'nvim-telescope/telescope-smart-history.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope-file-browser.nvim'
"}}}

"{{{ startup menu
Plug 'goolord/alpha-nvim'
"}}}

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
Plug 'rebelot/kanagawa.nvim'
" }}}

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

" {{{ ddc
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-around' " sources
Plug 'Shougo/ddc-matcher_head' " filters
Plug 'Shougo/ddc-sorter_rank' " filters
Plug 'Shougo/ddc-nvim-lsp'
Plug 'Shougo/ddc-converter_remove_overlap'
" }}}

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
nnoremap <silent> <Leader>cd :<C-u>cd %:p:h<CR>
nnoremap ^ :<C-u>so ~/.dotfiles/nvim/rc/init.vim<CR>
"}}}

"{{{ pluginConfig
lua require'colorizer'.setup()
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
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
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


EOF
nnoremap <silent> gf<CR>       <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gfv          <Cmd>vsplit<CR><Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gfs          <Cmd>split<CR><Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>i    <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>g    <Cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>f    <Cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <Leader>r    <Cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <Leader>s    <Cmd>lua vim.lsp.buf.signature_help()<CR>
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

"{{{jumpcursor
nmap [j <Plug>(jumpcursor-jump)
"}}}

"{{{lsp
lua <<EOF
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_init = function(client)
client.config.flags = {}
if client.config.flags then
	client.config.flags.allow_incremental_sync = true
	client.config.flags.debounce_text_changes = 200
end
end

require'nvim-lsp-installer'.setup {}
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

require'lspconfig'.clangd.setup {
        on_init = on_init;
        capabilities = capabilities;
}
EOF
"}}}


"{{{fzf
command! -bar MoveBack if &buftype == 'nofile' && (winwidth(0) < &columns / 3 || winheight(0) < &lines / 3) | execute "normal! \<c-w>\<c-p>" | endif
"nnoremap <silent> <Leader>mf :MoveBack<BAR>Files<CR>
"nnoremap <silent> <Leader>mb  :MoveBack<BAR>Buffers<CR>
nnoremap <leader>ff <cmd>FZF<CR>

function! s:plug_help_sink(line)
	let dir = g:plugs[a:line].dir
	for pat in ['doc/*.txt', 'README.md']
		let match = get(split(globpath(dir, pat), "\n"), 0, '')
		if len(match)
			execute 'tabedit' match
			return
		endif
	endfor
	tabnew
	execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
	\ 'source': sort(keys(g:plugs)),
	\ 'sink':   function('s:plug_help_sink')}))


let g:fzf_action = {
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-x': 'split',
	\ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '40%' }

"}}}

"{{{kanagawa.nvim
lua << EOF
-- Default options:
require('kanagawa').setup({
	undercurl = true,           -- enable undercurls
	commentStyle = "italic",
	functionStyle = "NONE",
	keywordStyle = "italic",
	statementStyle = "bold",
	typeStyle = "NONE",
	variablebuiltinStyle = "italic",
	specialReturn = true,       -- special highlight for the return keyword
	specialException = true,    -- special highlight for exception handling keywords
	transparent = false,        -- do not set background color
	dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
	globalStatus = false,       -- adjust window separators highlight for laststatus=3
	colors = {},
	overrides = {},
})

EOF
"}}}

"{{{toggleterm
lua << EOF
require('toggleterm').setup({
	open_mapping = [[<c-\>]],
	shade_filetypes = { 'none' },
	direction = 'horizontal',
	insert_mappings = false,
	start_in_insert = true,
	float_opts = { border = 'rounded', winblend = 3 },
	size = function(term)
		if term.direction == 'horizontal' then
			return 15
		elseif term.direction == 'vertical' then
			return math.floor(vim.o.columns * 0.4)
		end
	end,
})

local float_handler = function(term)
	if vim.fn.mapcheck('jk', 't') ~= '' then
		vim.api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
		vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<esc>')
	end
end

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({
	cmd = 'lazygit',
	dir = 'git_dir',
	hidden = true,
	direction = 'float',
	on_open = float_handler,
})

local toggleLazegit = function()
	lazygit:toggle()
end
vim.api.nvim_create_user_command('Lazygit', toggleLazegit, {})
EOF
" set
autocmd TermEnter term://*toggleterm#*
	\ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
"nnoremap <Leader>lg :<C-u>Lazygit<CR>
"}}}

"{{{gopls
lua <<EOF
function OrgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = {only = {"source.organizeImports"}}
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end
EOF

autocmd BufWritePre *.go lua OrgImports(1000)
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)
"}}}

"{{{Comment.nvim
lua << EOF
require('Comment').setup({
	---Add a space b/w comment and the line
	---@type boolean|fun():boolean
	padding = true,

	---Whether the cursor should stay at its position
	---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
	---@type boolean
	sticky = true,

	---Lines to be ignored while comment/uncomment.
	---Could be a regex string or a function that returns a regex string.
	---Example: Use '^$' to ignore empty lines
	---@type string|fun():string
	ignore = nil,

	---LHS of toggle mappings in NORMAL + VISUAL mode
	---@type table
	toggler = {
		---Line-comment toggle keymap
		line = 'gcc',
		---Block-comment toggle keymap
		block = 'gbc',
	},

	---LHS of operator-pending mappings in NORMAL + VISUAL mode
	---@type table
	opleader = {
		---Line-comment keymap
		line = 'gc',
		---Block-comment keymap
		block = 'gb',
	},

	---LHS of extra mappings
	---@type table
	extra = {
		---Add comment on the line above
		above = 'gcO',
		---Add comment on the line below
		below = 'gco',
		---Add comment at the end of line
		eol = 'gcA',
	},

	---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
	---NOTE: If `mappings = false` then the plugin won't create any mappings
	---@type boolean|table
	mappings = {
		---Operator-pending mapping
		---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
		---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
		basic = true,
		---Extra mapping
		---Includes `gco`, `gcO`, `gcA`
		extra = true,
		---Extended mapping
		---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
		extended = false,
	},

	---Pre-hook, called before commenting the line
	---@type fun(ctx: Ctx):string
	pre_hook = nil,

	---Post-hook, called after commenting is done
	---@type fun(ctx: Ctx)
	post_hook = nil,
})
EOF
"}}}

"{{{nvim-scrollbar
lua << EOF
require("scrollbar").setup({
	show = true,
	show_in_active_only = false,
	set_highlights = true,
	folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
	max_lines = false, -- disables if no. of lines in buffer exceeds this
	handle = {
		text = " ",
		color = nil,
		cterm = nil,
		highlight = "CursorColumn",
		hide_if_all_visible = true, -- Hides handle if all lines are visible
	},
	marks = {
		Search = {
			text = { "-", "=" },
			priority = 0,
			color = nil,
			cterm = nil,
			highlight = "Search",
		},
		Error = {
			text = { "-", "=" },
			priority = 1,
			color = nil,
			cterm = nil,
			highlight = "DiagnosticVirtualTextError",
		},
		Warn = {
			text = { "-", "=" },
			priority = 2,
			color = nil,
			cterm = nil,
			highlight = "DiagnosticVirtualTextWarn",
		},
		Info = {
			text = { "-", "=" },
			priority = 3,
			color = nil,
			cterm = nil,
			highlight = "DiagnosticVirtualTextInfo",
		},
		Hint = {
			text = { "-", "=" },
			priority = 4,
			color = nil,
			cterm = nil,
			highlight = "DiagnosticVirtualTextHint",
		},
		Misc = {
			text = { "-", "=" },
			priority = 5,
			color = nil,
			cterm = nil,
			highlight = "Normal",
		},
	},
	excluded_buftypes = {
		"terminal",
	},
	excluded_filetypes = {
		"prompt",
		"TelescopePrompt",
	},
	autocmd = {
		render = {
			"BufWinEnter",
			"TabEnter",
			"TermEnter",
			"WinEnter",
			"CmdwinLeave",
			"TextChanged",
			"VimResized",
			"WinScrolled",
		},
		clear = {
			"BufWinLeave",
			"TabLeave",
			"TermLeave",
			"WinLeave",
		},
	},
	handlers = {
		diagnostic = true,
		search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
	},
})
EOF
"}}}

"{{{alpha

function! s:print_plugins_message() abort
	let l:packer = stdpath('data') .'/site/pack/packer/start/packer.nvim'
	let s:footer_icon = ''
	if exists('g:dashboard_footer_icon')
		let s:footer_icon = get(g:,'dashboard_footer_icon','')
	endif

	if has('nvim')
		let l:vim = 'neovim'
	else
		let l:vim = 'vim'
	endif

	if exists('*dein#get')
		let l:total_plugins = len(dein#get())
	elseif exists('*plug#begin')
		let l:total_plugins = len(keys(g:plugs))
	elseif isdirectory(l:packer)
		let l:total_plugins = luaeval('#vim.tbl_keys(packer_plugins)')
	else
		return [s:footer_icon . ' Have fun with ' . l:vim]
	endif

	let l:footer=[]
	let footer_string= s:footer_icon . l:vim .' loaded ' . l:total_plugins . ' plugins '
	call insert(l:footer,footer_string)
	return l:footer
endfunction

lua << EOF
local dashboard= require'alpha.themes.dashboard'

local banner = {
	"                                                    ",
	" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                    ",
}

dashboard.section.header.val = banner
dashboard.section.footer.val = vim.fn['s:print_plugins_message']()

dashboard.section.buttons.val = {
	dashboard.button('e', '  New file', ':enew<CR>'),
	dashboard.button("h", "  Recently opened files", ":Telescope my_mru<CR>"),
	dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
	dashboard.button('s', '  Settings', ':e ~/.dotfiles/nvim/rc/init.vim<CR>'),
	dashboard.button("u", "  Update plugins", ":PlugUpdate<CR>"),
	dashboard.button("q", "  Exit", ":qa<CR>"),
}

require'alpha'.setup(dashboard.config)

EOF
"}}}

"{{{telescope
lua << EOF
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local config = require("telescope.config")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local telescope_builtin = require("telescope.builtin")
local Path = require("plenary.path")

local action_state = require("telescope.actions.state")
local custom_actions = {}

vim.api.nvim_set_keymap("n", "[fuzzy-finder]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "[fuzzy-finder]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "Z", "[fuzzy-finder]", {})
vim.api.nvim_set_keymap("v", "Z", "[fuzzy-finder]", {})

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "> ",
		selection_caret = "> ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "flex",
		layout_config = {
			width = 0.8,
			horizontal = {
				mirror = false,
				prompt_position = "top",
				preview_cutoff = 120,
				preview_width = 0.5,
			},
			vertical = {
				mirror = false,
				prompt_position = "top",
				preview_cutoff = 120,
				preview_width = 0.5,
			},
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules/*", ".git/*" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "truncate" },
		dynamic_preview_title = true,
		winblend = 10,
		border = {},
		borderchars = {
				{ '─', '│', '─', '│', '┌', '┐', '┘', '└' },
				prompt = {'─', '│', ' ', '│', '┌', '┐', '│', '│'},
				results = {'─', '│', '─', '│', '├', '┤', '┘', '└'},
				preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
			},
		color_devicons = true,
		use_less = true,
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			n = { ["<C-t>"] = action_layout.toggle_preview },
			i = {
				["<C-t>"] = action_layout.toggle_preview,
				["<C-x>"] = false,
				["<C-s>"] = actions.select_horizontal,
				["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<C-q>"] = actions.send_selected_to_qflist,
				["<CR>"] = actions.select_default + actions.center,
				["<C-g>"] = custom_actions.multi_selection_open,
			},
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
			["i"] = {
			  -- your custom insert mode mappings
			},
			["n"] = {
			  -- your custom normal mode mappings
			},
			},
		},
	}
})
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('file_browser')

local function remove_duplicate_paths(tbl, cwd)
	local res = {}
	local hash = {}
	for _, v in ipairs(tbl) do
		local v1 = Path:new(v):normalize(cwd)
		if not hash[v1] then
			res[#res + 1] = v1
			hash[v1] = true
		end
	end
	return res
end

local function join_uniq(tbl, tbl2)
	local res = {}
	local hash = {}
	for _, v1 in ipairs(tbl) do
		res[#res + 1] = v1
		hash[v1] = true
	end

	for _, v in pairs(tbl2) do
		if not hash[v] then
			table.insert(res, v)
		end
	end
	return res
end

local function filter_by_cwd_paths(tbl, cwd)
	local res = {}
	local hash = {}
	for _, v in ipairs(tbl) do
		if v:find(cwd, 1, true) then
			local v1 = Path:new(v):normalize(cwd)
			if not hash[v1] then
				res[#res + 1] = v1
				hash[v1] = true
			end
		end
	end
	return res
end

local function requiref(module)
	require(module)
end

telescope_builtin.my_mru = function(opts)
	local get_mru = function(opts2)
		local res = pcall(requiref, "telescope._extensions.frecency")
		if not res then
			return vim.tbl_filter(function(val)
				return 0 ~= vim.fn.filereadable(val)
			end, vim.v.oldfiles)
		else
			local db_client = require("telescope._extensions.frecency.db_client")
			db_client.init()
			-- too slow
			-- local tbl = db_client.get_file_scores(opts, vim.fn.getcwd())
			local tbl = db_client.get_file_scores(opts2)
			local get_filename_table = function(tbl2)
				local res2 = {}
				for _, v in pairs(tbl2) do
					res2[#res2 + 1] = v["filename"]
				end
				return res2
			end
			return get_filename_table(tbl)
		end
	end
	local results_mru = get_mru(opts)
	local results_mru_cur = filter_by_cwd_paths(results_mru, vim.loop.cwd())

	local show_untracked = utils.get_default(opts.show_untracked, true)
	local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
	if show_untracked and recurse_submodules then
		error("Git does not suppurt both --others and --recurse-submodules")
	end
	local cmd = {
		"git",
		"ls-files",
		"--exclude-standard",
		"--cached",
		show_untracked and "--others" or nil,
		recurse_submodules and "--recurse-submodules" or nil,
	}
	local results_git = utils.get_os_command_output(cmd)

	local results = join_uniq(results_mru_cur, results_git)

	pickers.new(opts, {
		prompt_title = "MRU",
		finder = finders.new_table({
			results = results,
			entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
		}),
		-- default_text = vim.fn.getcwd(),
		sorter = conf.file_sorter(opts),
		previewer = conf.file_previewer(opts),
	}):find()
end

telescope_builtin.grep_prompt = function(opts)
	opts.search = vim.fn.input("Grep String > ")
	telescope_builtin.my_grep(opts)
end

telescope_builtin.my_grep = function(opts)
	require("telescope.builtin").grep_string({
		opts = opts,
		prompt_title = "grep_string: " .. opts.search,
		search = opts.search,
		use_regex = true,
	})
end

telescope_builtin.my_grep_in_dir = function(opts)
	opts.search = vim.fn.input("Grep String > ")
	opts.search_dirs = {}
	opts.search_dirs[1] = vim.fn.input("Target Directory > ")
	require("telescope.builtin").grep_string({
		opts = opts,
		prompt_title = "grep_string(dir): " .. opts.search,
		search = opts.search,
		search_dirs = opts.search_dirs,
	})
end

telescope_builtin.memo = function(opts)
	require("telescope.builtin").find_files({
		opts = opts,
		prompt_title = "MemoList",
		find_command = { "find", vim.g.memolist_path, "-type", "f", "-exec", "ls", "-1ta", "{}", "+" },
	})
end

vim.api.nvim_set_keymap("n", "<Leader>gf", "<Cmd>Telescope git_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]>", "<Cmd>Telescope my_grep_in_dir<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap(
--	"v",
--	"[fuzzy-finder],",
--	"y:Telescope my_grep search=<C-r>=escape(@\", '\\.*$^[] ')<CR>",
--	{ noremap = true }
--)
--vim.api.nvim_set_keymap(
--	"n",
--	"<Leader>/",
--	":<C-u>Telescope my_grep search=<C-r>=expand('<cword>')<CR>",
--	{ noremap = true }
--)
--vim.api.nvim_set_keymap(
--	"n",
--	"[fuzzy-finder]/",
--	":<C-u>Telescope my_grep search=<C-r>=expand('<cword>')<CR>",
--	{ noremap = true }
--)
vim.api.nvim_set_keymap("n", "[fuzzy-finder]s", "<Cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]h", "<Cmd>Telescope help_tags<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]c", "<Cmd>Telescope commands<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]t", "<Cmd>Telescope treesitter<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]q", "<Cmd>Telescope quickfix<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]l", "<Cmd>Telescope loclist<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]m", "<Cmd>Telescope marks<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]r", "<Cmd>Telescope registers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[fuzzy-finder]*", "<Cmd>Telescope grep_string<CR>", { noremap = true, silent = true })
-- git
vim.api.nvim_set_keymap(
	"n",
	"<Leader>gs",
	"<Cmd>lua require('telescope.builtin').git_status()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>gc",
	"<Cmd>lua require('telescope.builtin').git_commits()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>gb",
	"<Cmd>lua require('telescope.builtin').git_branches()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<Leader><Leader>", "<Cmd>Telescope my_mru<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<C-t>", "<BS><Cmd>Telescope command_history<CR>", { noremap = true, silent = true })
EOF
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <Leader>fc <cmd>Telescope current_buffer_fuzzy_find<CR>

"}}}

"{{{lexima
let s:rules = []

let s:rules += [
\ { 'filetype': ['typescript', 'typescriptreact'], 'char': '>', 'at': '\s([a-zA-Z, ]*\%#)',            'input': '<Left><C-o>f)<Right>a=> {}<Esc>',                 },
\ { 'filetype': ['typescript', 'typescriptreact'], 'char': '>', 'at': '\s([a-zA-Z]\+\%#)',             'input': '<Right> => {}<Left>',              'priority': 10 },
\ { 'filetype': ['typescript', 'typescriptreact'], 'char': '>', 'at': '[a-z]((.*\%#.*))',              'input': '<Left><C-o>f)a => {}<Esc>',                       },
\ { 'filetype': ['typescript', 'typescriptreact'], 'char': '>', 'at': '[a-z]([a-zA-Z]\+\%#)',          'input': ' => {}<Left>',                                    },
\ { 'filetype': ['typescript', 'typescriptreact'], 'char': '>', 'at': '(.*[a-zA-Z]\+<[a-zA-Z]\+>\%#)', 'input': '<Left><C-o>f)<Right>a=> {}<Left>',                },
\ ]

for s:rule in s:rules
	call lexima#add_rule(s:rule)
endfor
"}}}

" {{{ lualine
lua << EOF
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
        bg       = '#202328',
        fg       = '#bbc2cf',
        yellow   = '#ECBE7B',
        cyan     = '#008080',
        darkblue = '#081633',
        green    = '#b4be82',
        orange   = '#e2a478',
        violet   = '#a093c7',
        magenta  = '#c678dd',
        blue     = '#84a0c6',
        red      = '#e27878',
}

local conditions = {
        buffer_not_empty = function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        hide_in_width = function()
                return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
                local filepath = vim.fn.expand('%:p:h')
                local gitdir = vim.fn.finddir('.git', filepath .. ';')
                return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
}

-- Config
local config = {
        options = {
                -- Disable sections and component separators
                component_separators = '',
                section_separators = '',
                theme = {
                        normal = { c = { fg = colors.fg, bg = colors.bg } },
                        inactive = { c = { fg = colors.fg, bg = colors.bg } },
                },
        },
        sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                -- These will be filled later
                lualine_c = {},
                lualine_x = {},
        },
        inactive_sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                lualine_c = {},
                lualine_x = {},
        },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
end

ins_left {
        function()
                return '▊'
        end,
        color = { fg = colors.blue }, -- Sets highlighting of component
        padding = { left = 0, right = 1 }, -- We don't need space before this
}

local function setModeColor(mode)
        local cmd = vim.api.nvim_command
        local black_fg = '#282c34'

        local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [''] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red,
        }
        cmd('hi Mode guibg=' .. mode_color[mode] .. ' guifg=' .. black_fg .. ' gui=bold')
        cmd('hi ModeSeparator  guibg=' .. colors.bg .. ' guifg=' .. mode_color[mode])
end

local function getmode() 
        local left_separator = ''
        local right_separator = ''
        local space = ' '
        --local mode = vim.api.nvim_get_mode()['mode']
        local mode = vim.fn.mode()
        local modeTable = {
                n = 'N',
                i = 'I',
                v = 'v',
                [''] = 'V',
                V = 'V',
                c = 'C',
                no = 'N·Operator Pending',
                s = 'Select',
                S = 'S·Line',
                [''] = 'S·Block',
                ic = 'I',
                ix = 'I',
                R = 'Replace',
                Rv = 'V.Replace',
                cv = 'Vim Ex',
                ce = 'Ex',
                r = 'Prompt',
                rm = 'More',
                ['r?'] = 'Confirm',
                ['!'] = 'Shell',
                t = 'T',
          }
        setModeColor(mode)
        return  '%#ModeSeparator#'
                .. left_separator
                .. '%#Mode# '
                .. modeTable[mode]
                .. ' %#ModeSeparator#'
                .. right_separator
end

ins_left {
        function()
                return getmode()
        end
}

ins_left {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' },
}


ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.cyan },
        },
}

ins_left {
        'diff',
        -- Is it me or the symbol for modified us really weird
        symbols = { added = ' ', modified = '柳 ', removed = ' ' },
        diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.orange },
        removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
        function()
                return '%='
        end,
}

ins_left {
        -- Lsp server name .
        function()
                local msg = 'No Active Lsp'
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                        return msg
                end
                for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                return client.name
                        end
                end
                return msg
        end,
        icon = ' LSP:',
        color = { fg = colors.fg, gui = 'bold' },
}

ins_right {
        'branch',
        icon = '',
        color = { fg = colors.violet, gui = 'bold' },
}

ins_right { 'location' }

ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_right {
        -- filesize component
        'filesize',
        cond = conditions.buffer_not_empty,
}

-- Add components to right sections
ins_right {
        'o:encoding', -- option component same as &encoding in viml
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = 'bold' },
}

ins_right {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = 'bold' },
}


ins_right {
        function()
                return '▊'
        end,
        color = { fg = colors.blue },
        padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
EOF
"set statusline=3
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
	nmap <silent> <buffer> <C-s> <Plug>(fern-action-new-dir)
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

" {{{ translate.vim
let g:translate_source = "en"
let g:translate_target = "ja"
vmap <Leader>t <Plug>(VTranslate)
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

"{{{vim-goimports
let g:goimports = 1
"}}}

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

augroup Cursor
        autocmd WinLeave * setlocal nocursorline "カレントウィンドウから離れたらカーソルハイライトを消す
        highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666 "全角スペースを見えるようにする
        autocmd BufNewFile,BufRead * match ZenkakuSpace /　/
augroup END


command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")
"}}}

" {{{ other
if has('win32')
	cd ~
endif
colorscheme iceberg
filetype plugin indent on
" }}}
