return {
  "glepnir/lspsaga.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  event = "BufReadPre",
  config = function()
    local lspsaga = require("lspsaga")
    local vim = vim
    local api = vim.api
    local keymap = vim.keymap.set
    local silent = { silent = true }
    local opts = { noremap = true, silent = true }

    lspsaga.setup()

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

    keymap("n", "<Plug>(lsp);r", "<cmd>Lspsaga rename<cr>", opts)
    keymap("n", "<Plug>(lsp);a", "<cmd>Lspsaga code_action<cr>", opts)
    keymap("x", "<Plug>(lsp);a", ":<c-u>Lspsaga range_code_action<cr>", opts)
    -- keymap("n", "<C-k>", "<cmd>Lspsaga hover_doc<cr>", opts)
    -- keymap("n", "<Plug>(lsp);o", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
    keymap("n", "<Plug>(lsp);l", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    keymap("n", "<Plug>(lsp);j", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    keymap("n", "<Plug>(lsp);k", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    keymap("n", "<Plug>(lsp);f", "<cmd>Lspsaga lsp_finder<CR>", opts)
    keymap("n", "<Plug>(lsp);h", "<cmd>Lspsaga signature_help<CR>", opts)
    keymap("n", "gd", "<cmd>Lspsaga preview_definition<CR>", silent)
    keymap("n", "<Plug>(lsp);o", "<cmd>LSoutlineToggle<CR>", silent)
    keymap("n", "<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>", opts)
    keymap("n", "<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>", opts)

    keymap("n", "K", function()
      if not lua_help() then
        vim.cmd([[Lspsaga hover_doc]])
      else
        vim.cmd([[execute 'h ' . expand('<cword>') ]])
      end
    end)


    -- Lsp finder find the symbol definition implement reference
    -- if there is no implement it will hide
    -- when you use action in finder like open vsplit then you can
    -- use <C-t> to jump back
    keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", silent)

    -- Code action
    keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", silent)

    -- Rename
    keymap("n", "gr", "<cmd>Lspsaga rename<CR>", silent)

    -- Peek Definition
    -- you can edit the definition file in this flaotwindow
    -- also support open/vsplit/etc operation check definition_action_keys
    -- support tagstack C-t jump back
    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", silent)

    -- Show line diagnostics
    keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", silent)

    -- Show cursor diagnostic
    keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", silent)

    -- Diagnsotic jump can use `<c-o>` to jump back
    keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", silent)
    keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", silent)

    -- Only jump to error
    keymap("n", "[E", function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, silent)
    keymap("n", "]E", function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, silent)

    -- Outline
    keymap("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", silent)

  end
}
