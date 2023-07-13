return {
  "famiu/bufdelete.nvim",
  config = function()
    vim.keymap.set("n", "<Leader>bbd", "<cmd>Bdelete<cr>", { noremap = true, silent=true })
  end
}
