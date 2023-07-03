return {
  "svermeulen/text-to-colorscheme.nvim",
  opts = {
    ai = {
      gpt_model = "gpt-3.5-turbo",
      openai_api_key = require("local_vimrc").OPENAI_AUTHKEY,
    },
  }
}
