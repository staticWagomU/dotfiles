return {
  "lambdalisue/fern.vim",
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    vim.g["fern#default_hidden"] = 1


    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap("n", "<leader>E", ":Fern %:h<cr>", opts)
    keymap("n", "<leader>e", ":Fern .<cr>", opts)

    vim.api.nvim_create_autocmd("FileType fern", {
      group = vim.api.nvim_create_augroup("my-fern", { clear = true }),
      buffer = bufnr,
      callback = function()
        local bufonly = { noremap = true, silent = true, buffer = true }

        vim.keymap.set("n", "@", "<Plug>(fern-action-cd):Fern .<cr>", bufonly)
        vim.keymap.set("n", "`", "<Plug>(fern-action-cd)", bufonly)
      end
    })
  end
}
