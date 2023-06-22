return {
  "ryicoh/deepl.vim",
  config = function()
    vim.g["deepl#endpoint"] = "https://api-free.deepl.com/v2/translate"
    local DEEPL_AUTHKEY = require("local_vimrc").DEEPL_AUTHKEY
    vim.g["deepl#auth_key"] = DEEPL_AUTHKEY
    vim.cmd[[
    " replace a visual selection
    vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
    vmap t<C-j> <Cmd>call deepl#v("JA")<CR>

    " translate a current line and display on a new line
    nmap t<C-e> yypV<Cmd>call deepl#v("EN")<CR>
    nmap t<C-j> yyp<Cmd>s/`/_'/g<CR>V<Cmd>call deepl#v("JA")<CR><Cmd>s/_'/`/g<CR>

    ]]
  end
}
