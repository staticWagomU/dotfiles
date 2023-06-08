return {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" }
  },
  config = function()
    require("lspsaga").setup({
      symbol_in_winbar = {
        enable = false,
        show_file = false,
      },
    })

    require("utils").on_attach(function()
      vim.keymap.set("n", "K", function()
        local ft = vim.o.filetype
        if ft == "vim" or ft == "help" then
          vim.cmd([[execute "h " . expand("<cword>") ]])
        else
          vim.cmd([[Lspsaga hover_doc]])
        end
      end)

      vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<cr>")
      vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<cr>")

      vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<cr>")
      vim.keymap.set("n", "gT", "<cmd>Lspsaga goto_type_definition<cr>")

      vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<cr>")
    end)
  end
}
