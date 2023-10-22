return {
  "epwalsh/obsidian.nvim",
  event = {
    "BufReadPre",
    "BufNewFile"
  },
  ft = { "markdown" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local dir = vim.fn.has("win32") == 1 and "~\\Documents\\MyLife" or "~/Documents/MyLife "
    require("obsidian").setup({
      dir = dir,
      notes_subdir = "pages",
    })
  end,
}
