require('toggleterm').setup({
	open_mapping = [[<c-\>]],
	shade_filetypes = { 'none' },
	direction = 'horizontal',
	insert_mappings = true,
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
