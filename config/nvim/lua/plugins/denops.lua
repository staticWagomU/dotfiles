local enabled = false
if enabled == true then
vim.g["denops_server_addr"] = "127.0.0.1:32123"
vim.g["g:denops#debug"] = 1
vim.cmd[[
let g:denops#server#service#deno_args = get(g:,
\ 'denops#server#service#deno_args', [
\ '-q',
\ '--no-check',
\ '--unstable',
\ '-A',
\ ]) + ['--inspect']
]]
end
return {
  "vim-denops/denops.vim",
  config = function()
  end,
}

