return {
  "yuki-yano/fuzzy-motion.vim",
  dependencies = {
    "vim-denops/denops.vim",
    "lambdalisue/kensaku.vim",
  },
  config = function()
    vim.keymap.set("n", "<Leader><Leader>", ":<C-u>FuzzyMotion<CR>", { noremap = true })
    vim.g.fuzzy_motion_word_regexp_list = {
      [[[0-9a-zA-Z_-]+]],
      [[([0-9a-zA-Z_-]|[.])+]],
      [[([0-9a-zA-Z]|[()<>.-_#''"]|(\s=+\s)|(,\s)|(:\s)|(\s=>\s))+]],
      [[\P{Script_Extensions=Latin}+]],
    }
    vim.g.fuzzy_motion_matchers = {'fzf', 'kensaku'}
  end,
}
