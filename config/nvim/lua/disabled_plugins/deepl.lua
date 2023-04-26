return {
  "ryicoh/deepl.vim",
  config = function()
    local vim = vim
    local keymap = vim.keymap.set
    vim.g["deepl#endpoint"] = "https://api-free.deepl.com/v2/translate"
    local DEEPL_AUTHKEY = require("local_vimrc").DEEPL_AUTHKEY
    vim.g["deepl#auth_key"] = DEEPL_AUTHKEY
    vim.cmd[[
    " replace a visual selection
    vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
    vmap t<C-j> <Cmd>call deepl#v("JA")<CR>

    " translate a current line and display on a new line
    nmap t<C-e> yypV<Cmd>call deepl#v("EN")<CR>
    nmap t<C-j> yypV<Cmd>call deepl#v("JA")<CR>

    ]]
  end
}
