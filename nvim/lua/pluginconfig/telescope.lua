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
local fb_actions = require "telescope".extensions.file_browser.actions
local trouble = require("trouble.providers.telescope")

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
			n = {
				["<C-t>"] = action_layout.toggle_preview,
				["<C-r>"] = trouble.open_with_trouble
			},
			i = {
				["<C-t>"] = action_layout.toggle_preview,
				["<C-x>"] = false,
				["<C-s>"] = actions.select_horizontal,
				["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<C-q>"] = actions.send_selected_to_qflist,
				["<CR>"] = actions.select_default + actions.center,
				["<C-g>"] = custom_actions.multi_selection_open,
				["<C-r>"] = trouble.open_with_trouble
			},
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
                file_browser = {
                        -- theme = "iceberg",
                        -- disables netrw and use telescope-file-browser in its place
                        hijack_netrw = true,
                        mappings = {
                                ["i"] = {
                                        -- your custom insert mode mappings
                                        ["<C-k>"] = fb_actions.create,
                                        ["<C-r>"] = fb_actions.rename,
                                        ["<C-c>"] = fb_actions.copy,
                                        ["<C-m>"] = fb_actions.move,
                                        ["<C-d>"] = fb_actions.remove,
                                },
                                ["n"] = {
                                        -- your custom normal mode mappings
                                },
                        },
                },
	}
})

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

local opts = { noremap = true, silent = true }

-- vim.api.nvim_set_keymap("n", "<Leader>gf", "<Cmd>Telescope git_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]>", "<Cmd>Telescope my_grep_in_dir<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]s", "<Cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]h", "<Cmd>Telescope help_tags<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]c", "<Cmd>Telescope commands<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]t", "<Cmd>Telescope treesitter<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]q", "<Cmd>Telescope quickfix<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]l", "<Cmd>Telescope loclist<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]m", "<Cmd>Telescope marks<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]r", "<Cmd>Telescope registers<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "[telescope]*", "<Cmd>Telescope grep_string<CR>", { noremap = true, silent = true })
-- git
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<Leader>gs",
-- 	"<Cmd>lua require('telescope.builtin').git_status()<CR>",
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<Leader>gc",
-- 	"<Cmd>lua require('telescope.builtin').git_commits()<CR>",
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<Leader>gb",
-- 	"<Cmd>lua require('telescope.builtin').git_branches()<CR>",
-- 	{ noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap("c", "<C-t>", "<BS><Cmd>Telescope command_history<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
        "n",
        "<Leader>e",
        ":Telescope file_browser<CR>",
        opts
)


vim.api.nvim_set_keymap(
        "n",
        "<Leader>E",
        ":Telescope find_files<CR>",
        opts
)

vim.api.nvim_set_keymap("n", "<Leader>tt", ":Telescope<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>tb", ":Telescope buffers<CR>", opts)

