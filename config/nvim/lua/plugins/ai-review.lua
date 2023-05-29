local OPENAI_API_KEY = require("local_vimrc").OPENAI_AUTHKEY
vim.cmd("let $OPENAI_API_KEY = '" .. OPENAI_API_KEY .. "'")


return {
  "yuki-yano/ai-review.nvim",
  dependencies = {
    "vim-denops/denops.vim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    chat_gpt = {
      model = 'gpt-3.5-turbo', -- or gpt-4
    },
  }
}
