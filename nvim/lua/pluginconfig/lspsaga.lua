local lspsaga = require("lspsaga")
local vim = vim
local api = vim.api

local function lua_help()
  if vim.bo.filetype ~= "lua" then
    return false
  end
  local current_line = api.nvim_get_current_line()
  local cursor_col = api.nvim_win_get_cursor(0)[2] + 1
  -- vim.fn.foo
  local s, e, m = current_line:find("fn%.([%w_]+)%(?")
  if s and s <= cursor_col and cursor_col <= e then
    vim.cmd("h " .. m)
    return true
  end
  -- vim.fn["foo"]
  s, e, m = current_line:find("fn%[['\"]([%w_#]+)['\"]%]%(?")
  if s and s <= cursor_col and cursor_col <= e then
    vim.cmd("h " .. m)
    return true
  end
  -- vim.api.foo
  s, e, m = current_line:find("api%.([%w_]+)%(?")
  if s and s <= cursor_col and cursor_col <= e then
    vim.cmd("h " .. m)
    return true
  end
  -- other vim.foo (e.g. vim.tbl_map, vim.lsp.foo, ...)
  s, e, m = current_line:find("(vim%.[%w_%.]+)%(?")
  if s and s <= cursor_col and cursor_col <= e then
    vim.cmd("h " .. m)
    return true
  end
  return false
end

local keymap = vim.keymap.set

lspsaga.init_lsp_saga({ -- defaults ...
  -- "single" | "double" | "rounded" | "bold" | "plus"
  border_style = "single",
  saga_winblend = 0,
  move_in_saga = { prev = "<C-p>", next = "<C-n>" },
  -- diagnostic_header = { " ", " ", " ", "ﴞ " },
  diagnostic_header = { "😡", "😥", "😤", "😐" },
  max_preview_lines = 10,
  code_action_icon = " ",
  -- if true can press number to execute the codeaction in codeaction window
  code_action_num_shortcut = true,
  -- same as nvim-lightbulb but async
  code_action_lightbulb = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = true,
  },
  -- finder icons
  finder_icons = {
    def = "  ",
    ref = "諭 ",
    link = "  ",
  },
  -- custom finder title winbar function type
  -- param is current word with symbol icon string type
  -- return a winbar format string like `%#CustomFinder#Test%*`
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>", -- quit can be a table
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  rename_action_quit = "<C-c>",
  -- definition_preview_icon = "  ",
  -- show symbols in winbar must nightly
  symbol_in_winbar = {
    in_custom = false,
    enable = true,
    separator = " ",
    show_file = true,
    click_support = false,
  },
  -- show outline
  show_outline = {
    win_position = "right",
    -- set the special filetype in there which in left like nvimtree neotree defx
    left_with = "",
    win_width = 30,
    auto_enter = true,
    auto_preview = true,
    virt_text = "┃",
    jump_key = "o",
    -- auto refresh when change buffer
    auto_refresh = true,
  },
})

vim.keymap.set("n", "[lsp]r", "<cmd>Lspsaga rename<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "[lsp]a", "<cmd>Lspsaga code_action<cr>", { silent = true, noremap = true })
vim.keymap.set("x", "[lsp]a", ":<c-u>Lspsaga range_code_action<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-k>", "<cmd>Lspsaga hover_doc<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[lsp]o", "<cmd>Lspsaga show_line_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "[lsp]j", "<cmd>Lspsaga diagnostic_jump_next<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "[lsp]k", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "[lsp]f", "<cmd>Lspsaga lsp_finder<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "[lsp]h", "<cmd>Lspsaga signature_help<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
vim.keymap.set("n", "[lsp]o", "<cmd>LSoutlineToggle<CR>", { silent = true })
vim.keymap.set(
  "n",
  "<C-b>",
  "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set(
  "n",
  "<C-f>",
  "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>",
  { silent = true, noremap = true }
)

keymap("n", "K", function()
  if not lua_help() then
    vim.lsp.buf.hover()
  end
end)


-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", { silent = true })

-- Hover Doc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm .<CR>", { silent = true })
-- if you want pass somc cli command into terminal you can do like this
-- open lazygit in lspsaga float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
