return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = { "<leader>e", "<leader>E" },
  config = function()
    require("oil").setup({})
    vim.keymap.set("n", "<leader>e", "<cmd>Oil .<cr>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>E", "<cmd>Oil %:p:h<cr>", { noremap = true, silent = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.keymap.set("n", "<leader>we", function()
          local oil = require("oil")
          local config = require("oil.config")
          if #config.columns == 1 then
            oil.set_columns({ "icon", "permissions", "size", "mtime" })
          else
            oil.set_columns({ "icon" })
          end
        end, { noremap = true, silent = true, buffer = true })
      end,
    }
    )
  end,
  event = { "BufReadPre", "BufNewFile" },
}
