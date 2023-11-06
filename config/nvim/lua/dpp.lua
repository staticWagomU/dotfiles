vim.opt.compatible = false

local joinpath = vim.fs.joinpath
local dpp_base = joinpath(vim.fn.expand("~"), ".cache", "dpp")
local github_base = joinpath(dpp_base, "repos", "github.com")

local dpp_src = joinpath(github_base, "Shougo", "dpp.vim")
local denops_src = joinpath(github_base, "vim-denops", "denops.vim")

local protocol_git = joinpath(github_base, "Shougo", "dpp-protocol-git")
local ext_installer = joinpath(github_base, "Shougo", "dpp-ext-installer")
local ext_lazy = joinpath(github_base, "Shougo", "dpp-ext-lazy")
local ext_local = joinpath(github_base, "Shougo", "dpp-ext-local")
local ext_toml = joinpath(github_base, "Shougo", "dpp-ext-toml")

vim.opt.runtimepath:prepend(vim.fs.normalize(dpp_src))
if vim.fn["dpp#min#load_state"](dpp_base) then
  vim.opt.runtimepath:append(denops_src)
  vim.opt.runtimepath:append(protocol_git)
  vim.opt.runtimepath:append(ext_installer)
  vim.opt.runtimepath:append(ext_lazy)
  vim.opt.runtimepath:append(ext_local)
  vim.opt.runtimepath:append(ext_toml)

  vim.api.nvim_create_autocmd("User", {
    pattern = { "DenopsReady" },
    callback = function()
      vim.fn["dpp#make_state"](vim.fs.joinpath(vim.fn.stdpath("config"), "ddp.ts"))
    end,
 })
end

vim.cmd[=[filetype indent plugin on]=]
if vim.fn.has("syntax") == true then
  vim.opt.syntax = "on"
end
