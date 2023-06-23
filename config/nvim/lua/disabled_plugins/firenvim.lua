return {
  "glacambre/firenvim",
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  cond = not not vim.g.started_by_firenvim,
  build = function()
    require("lazy").load({ plugins = "firenvim", wait = true })
    vim.fn["firenvim#install"](0)
  end,
  config = function ()
    vim.cmd[[
let g:firenvim_config = {
    \ 'localSettings': {
        \ '.*': {
            \ 'selector': 'textarea, div[role="textbox"]',
            \ 'priority': 0,
        \ }
    \ }
\ }
    ]]
    
  end
}
