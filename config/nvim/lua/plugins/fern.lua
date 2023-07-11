return {
  "lambdalisue/fern.vim",
  lazy = false,
  dependencies = {
    "vim-denops/denops.vim",
    "lambdalisue/fern-git-status.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/nerdfont.vim",
    "yuki-yano/fern-preview.vim",
  },
  config = function()
    vim.g["fern#default_hidden"] = 1
    vim.g["fern#renderer"] = "nerdfont"
    vim.g["fern#renderer#nerdfont#indent_markers"] = 1

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<Leader>f", "<cmd>Fern .<CR>", opts)
    vim.keymap.set("n", "<Leader>F", "<cmd>Fern %:h<CR>", opts)
    vim.keymap.set("n", "<C-f>", "<cmd>Fern . -reveal=%<CR>", opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "fern",
      -- group = vim.api.nvim_create_augroup("fern_settings"),
      callback = function()
        local buffer_silent = { silent =true, buffer = true }
        vim.opt_local.signcolumn="no"
        vim.opt_local.number=false

        vim.keymap.set("n", "<C-m>", "<Plug>(fern-action-move)", buffer_silent)
        vim.keymap.set("n", "<C-s>", "<Plug>(fern-action-new-dir)", buffer_silent)
        vim.keymap.set("n", "<Leader>cd", "<Plug>(fern-action-cd:cursor)", buffer_silent)
        vim.keymap.set("n", "p", "<Plug>(fern-action-preview:auto:toggle)", buffer_silent)
        vim.keymap.set("n", "<C-n>", "<Plug>(fern-action-preview:scroll:down:half)", buffer_silent)
        vim.keymap.set("n", "<C-p>", "<Plug>(fern-action-preview:scroll:up:half)", buffer_silent)
        vim.keymap.set("n", "`", "<Plug>(fern-action-preview:scroll:up:half)", buffer_silent)
        vim.keymap.set("n", "g.", "<Plug>(fern-action-hidden:toggle)", buffer_silent)
        vim.keymap.set("n", "-", "<Plug>(fern-action-leave)", buffer_silent)
        -- vim.keymap.set("n", "", "<Plug>(fern-action-)", buffer_silent)
      end,
    })
  end
}
