return {
  "ryicoh/deepl.vim",
  config = function()
    local vim = vim
    local keymap = vim.keymap.set
    vim.g["deepl#endpoint"] = "https://api-free.deepl.com/v2/translate"
    vim.g["deepl#auth_key"] = require("local_vimrc").DEEPL_AUTHKEY

    vim.keymap.set("v", "t<C-e>", vim.fn["deepl#v('EN')"])
    vim.keymap.set("v", "t<C-j>", vim.fn["deepl#v('JA')"])

    vim.cmd[[
    " translate a current line and display on a new line
    nmap t<C-e> yypV<Cmd>call deepl#v("EN")<CR>
    nmap t<C-j> yypV<Cmd>call deepl#v("JA")<CR>

    ]]
  end
}
