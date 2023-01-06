return {
  "yuki-yano/fuzzy-motion.vim",
  dependencies = { "vim-denops/denops.vim" },
  lazy = false,
  keys = {
    { "<Leader><Leader>", ":<C-u>FuzzyMotion<CR>", desc="FuzzyMotion" },
  },
  config = function()
    vim.keymap.set("n", "<Leader><Leader>", ":<C-u>FuzzyMotion<CR>", { noremap = true })
    vim.cmd [[
    let g:fuzzy_motion_word_regexp_list = [
    \ '[0-9a-zA-Z_-]+',
    \ '([0-9a-zA-Z_-]|[.])+',
    \ '([0-9a-zA-Z]|[()<>.-_#''"]|(\s=+\s)|(,\s)|(:\s)|(\s=>\s))+'
    \ ]
    ]]
  end,
}
