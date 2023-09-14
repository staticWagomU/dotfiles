require("utils").make_abbrev({
  { from = "ldi", to = "Lspsaga show_line_diagnostics" },
  { from = "lca", to = "Lspsaga code_action" },
  { from = "lgo", to = "Lspsaga outline" },
})

return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" }
  },
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({
      symbol_in_winbar = {
        enable = false,
      },
      ui = {
        code_action = '🌟'
      }
    })

    require("utils").on_attach(function()
      -- vim.keymap.set("n", "K", function()
      --   local ft = vim.lo.filetype
      --   if ft == "vim" or ft == "help" then
      --     vim.cmd.execute[["h " . expand("<cword>")]]
      --   else
      --     vim.cmd[[Lspsaga hover_doc]]
      --   end
      -- end)

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
      vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<cr>", opts)
      vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<cr>", opts)
      vim.keymap.set("n", "gvd", "<cmd>vs | Lspsaga goto_definition<cr>", opts)
      vim.keymap.set("n", "gsd", "<cmd>sp | Lspsaga goto_definition<cr>", opts)
      vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<cr>", opts)
      vim.keymap.set("n", "gT", "<cmd>Lspsaga goto_type_definition<cr>", opts)
      vim.keymap.set("n", "gvt", "<cmd>vs | Lspsaga goto_type_definition<cr>", opts)
      vim.keymap.set("n", "gst", "<cmd>sp | Lspsaga goto_type_definition<cr>", opts)
      vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<cr>", opts)
      vim.keymap.set("n", "[l", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
      vim.keymap.set("n", "]l", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
      vim.keymap.set("n", "<Space>lo", "<cmd>Lspsaga outline<cr>", opts)
      -- vim.keymap.set({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<cr>", opts)
    end)
  end
}
