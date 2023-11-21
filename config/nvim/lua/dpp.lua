local dpp_base = require("utils").dpp_basePath
local tsPath = vim.fs.joinpath(vim.fn.stdpath("config"), "dpp.ts")
if vim.fn["dpp#min#load_state"](dppBase) then
	vim.api.nvim_create_autocmd("User", {
		pattern = "DenopsReady",
		callback = function()
			vim.fn["dpp#make_state"](dppBase, tsPath)
		end,
	})
end

vim.fn["dpp#source"]()
vim.api.nvim_create_user_command(
	"DppInstall",
	function()
		vim.fn["dpp#async_ext_action"]("installer", "install")
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppUpdate",
	function()
		vim.fn["dpp#async_ext_action"]("installer", "update")
	end,
	{}
)

vim.api.nvim_create_user_command(
	"DppMakeState",
	function()
		vim.fn["dpp#make_state"](dppBase, tsPath)
	end,
	{}
)

vim.api.nvim_create_user_command(
	"DppLoad",
	function()
		vim.fn["dpp#min#load_state"](dppBase)
	end,
	{}
)

vim.api.nvim_create_user_command(
	"DppInstall",
	function()
		vim.fn["dpp#async_ext_action"]("installer", "getNotInstalled", { maxProcess = 10 })
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppUpdate",
	function()
		vim.fn["dpp#async_ext_action"]("installer", "update", { maxProcess = 10 })
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppSource",
	function()
		vim.fn["dpp#source"]()
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppClear",
	function()
		vim.fn["dpp#clear_state"]()
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppGet",
	function()
		vim.fn["dpp#get"]()
	end,
	{}
)

vim.cmd("filetype indent plugin on")
if vim.fn.has("syntax") then
	vim.cmd.syntax("on")
end
