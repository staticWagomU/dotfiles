local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-symbols.nvim",
    "crispgm/telescope-heading.nvim",
    "LinArcX/telescope-changes.nvim",
    "nvim-telescope/telescope-rg.nvim",
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-github.nvim",
    "lambdalisue/mr.vim",
  },
  cmd = { "Telescope", "RecentWrittenFiles", "RecentUsedFiles" },
  keys = {
    {"<Leader>tg", ":Telescope git_files<CR>", desc="Telescope git_files"},
    {"<Leader>te", ":Telescope find_files<CR>", desc="Telescope find_files"},
    {"<Leader>tt", ":Telescope<CR>", desc="Telescope "},
    {"<Leader>tb", ":Telescope buffers<CR>", desc="Telescope "},
    {"<Leader>tf", ":Telescope current_buffer_fuzzy_find<CR>", desc="Telescope "},
    {"<Leader>tw", ":RecentWrittenFiles<CR>", desc="Telescope "},
    {"<Leader>tu", ":RecentUsedFiles<CR>", desc="Telescope "},
  },
}

function M.config()
  local actions = require("telescope.actions")
  local action_layout = require("telescope.actions.layout")
  local telescope_builtin = require("telescope.builtin")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local conf = require("telescope.config").values
  local keymap = vim.keymap.set


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
        },
        i = {
          ["<C-t>"] = action_layout.toggle_preview,
          ["<C-x>"] = false,
          ["<C-s>"] = actions.select_horizontal,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
          ["<C-q>"] = actions.send_selected_to_qflist,
          ["<CR>"] = actions.select_default + actions.center,
          -- ["<C-g>"] = custom_actions.multi_selection_open,
        },
      },
    },
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

  local function recent_written_files(opts)
    local safe_opts = opts or {}
    local list = vim.fn["mr#mrw#list"]()
    pickers.new(safe_opts, {
      prompt_title = "Recent written files",
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(safe_opts),
      }),
      previewer = conf.file_previewer(safe_opts),
      sorter = conf.file_sorter(safe_opts),
    }):find()
  end

  local function recent_used_files(opts)
    local safe_opts = opts or {}
    local list = vim.fn["mr#mru#list"]()
    pickers.new(safe_opts, {
      prompt_title = "Recent used files",
      finder = finders.new_table({
        results = list,
        entry_maker = make_entry.gen_from_file(safe_opts),
      }),
      previewer = conf.file_previewer(safe_opts),
      sorter = conf.file_sorter(safe_opts),
    }):find()
  end

  vim.api.nvim_create_user_command("RecentWrittenFiles", function()
    recent_written_files()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("RecentUsedFiles", function()
    recent_used_files()
  end, { nargs = 0 })

  local opts = { noremap = true, silent = true }

  keymap("n", "<Leader>tg", ":Telescope git_files<CR>", opts)
  keymap("n", "<Leader>te", ":Telescope find_files<CR>", opts)
  keymap("n", "<Leader>tt", ":Telescope<CR>", opts)
  keymap("n", "<Leader>tb", ":Telescope buffers<CR>", opts)
  keymap("n", "<Leader>tf", ":Telescope current_buffer_fuzzy_find<CR>", opts)
  keymap("n", "<Leader>tw", ":RecentWrittenFiles<CR>", opts)
  keymap("n", "<Leader>tu", ":RecentUsedFiles<CR>", opts)
end



return M
