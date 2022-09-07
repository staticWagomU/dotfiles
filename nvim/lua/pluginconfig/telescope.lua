local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local telescope_builtin = require("telescope.builtin")
local custom_actions = {}
local fb_actions = require "telescope".extensions.file_browser.actions

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
      width = 0.9,
      horizontal = {
        mirror = false,
        prompt_position = "bottom",
        preview_cutoff = 120,
        preview_width = 0.5,
      },
      vertical = {
        mirror = false,
        prompt_position = "bottom",
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
      -- prompt = {'─', '│', ' ', '│', '┌', '┐', '│', '│'},
      -- results = {'─', '│', '─', '│', '├', '┤', '┘', '└'},
      prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
    color_devicons = true,
    use_less = true,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = {
        ["<C-t>"] = action_layout.toggle_preview,
        ["cd"] = function(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          local dir = vim.fn.fnamemodify(selection.path, ":p:h")
          require("telescope.actions").close(prompt_bufnr)
          -- Depending on what you want put `cd`, `lcd`, `tcd`
          vim.cmd(string.format("silent lcd %s", dir))
        end
      },
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
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<C-k>"] = fb_actions.create,
          ["<C-r>"] = fb_actions.rename,
          ["<C-c>"] = fb_actions.copy,
          ["<C-m>"] = fb_actions.move,
          ["<C-d>"] = fb_actions.remove,
        },
        ["n"] = {
          ["<C-k>"] = fb_actions.create,
          ["<C-r>"] = fb_actions.rename,
          ["<C-c>"] = fb_actions.copy,
          ["<C-m>"] = fb_actions.move,
          ["<C-d>"] = fb_actions.remove,
        },
      },
    },
  }
})

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
vim.api.nvim_set_keymap("c", "<C-t>", "<BS><Cmd>Telescope command_history<CR>", { noremap = true, silent = true })

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
vim.api.nvim_set_keymap("n", "<Leader>tf", ":Telescope current_buffer_fuzzy_find<CR>", opts)
