local actions = require "lir.actions"
local mark_actions = require "lir.mark.actions"
local clipboard_actions = require "lir.clipboard.actions"
local keymap = vim.keymap.set
local colors = require("neobeans.core").get_dark_colors()

require "lir".setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ["l"]     = actions.edit,
    ["<CR>"]  = actions.edit,
    ["<C-s>"] = actions.split,
    ["<C-v>"] = actions.vsplit,
    ["<C-t>"] = actions.tabedit,

    ["h"] = actions.up,
    ["q"] = actions.quit,
    ["<ESC>"] = actions.quit,

    ["K"] = actions.mkdir,
    ["N"] = actions.newfile,
    ["R"] = actions.rename,
    ["@"] = actions.cd,
    ["Y"] = actions.yank_path,
    ["."] = actions.toggle_show_hidden,
    ["D"] = actions.delete,

    ["J"] = function()
      mark_actions.toggle_mark()
      vim.cmd("normal! j")
    end,
    ["C"] = clipboard_actions.copy,
    ["X"] = clipboard_actions.cut,
    ["P"] = clipboard_actions.paste,
  },
  float = {
    winblend = 10,
    curdir_window = {
      enable = false,
      highlight_dirname = false,
    },
    win_opts = function()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      return {
        border = require("lir.float.helper").make_border_opts({
          "┌", "─", "┐", "│", "┘", "─", "└", "│",
        }, "Normal"),
        width = width,
        height = height,
        row = math.floor((vim.o.columns - width) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
      }
    end,
  },
  hide_cursor = true,
  on_init = function()
    -- use visual mode
    vim.api.nvim_buf_set_keymap(
      0,
      "x",
      "J",
      ":<C-u>lua require'lir.mark.actions'.toggle_mark('v')<CR>",
      { noremap = true, silent = true }
    )

    -- echo cwd
    vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
  end,
}

-- custom folder icon
require("nvim-web-devicons").set_icon({
  lir_folder_icon = {
    icon = "",
    color = colors.blue,
    name = "LirFolderNode"
  }
})

require("lir.git_status").setup({
  show_ignored = false
})

keymap("n", "<Leader>e", "<cmd>lua require'lir.float'.toggle()<cr>", { noremap = true, silent = true })
