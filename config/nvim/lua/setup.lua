local basePath = vim.fs.joinpath(require("utils").dpp_basePath .. "github.com")
if not vim.uv.fs_stat(basePath) then
	vim.fn.mkdir(basePath, "p", 0700)
end

local split = require("utils").split
local function clone(plugins)
	for _, p in ipairs(plugins) do
		local owner =  split(p, "/")[1]
		local ownersRepo = vim.fs.joinpath(basePath, owner)
		if not vim.loop.fs_stat(ownersRepo) then
			vim.fn.mkdir(ownersRepo, "p", 0700)
		end

		local repoPath = vim.fs.joinpath(basePath, p)
		if not vim.loop.fs_stat(repoPath) then
			vim.fn.system({
				"git",
				"clone",
				"https://github.com/" .. p .. ".git",
				repoPath
			})
		end
	end
end

local function Init()
	local prependPlugins = {
		"Shougo/dpp.vim",
	}
	for _, p in ipairs(prependPlugins) do
		vim.opt.runtimepath:prepend(vim.fs.joinpath(basePath, p))
	end
	clone(prependPlugins)
	local appendPlugins = {
		"Shougo/dpp-ext-lazy",
		"Shougo/dpp-ext-installer",
		"Shougo/dpp-ext-packspec",
		"Shougo/dpp-ext-toml",
		"Shougo/dpp-protocol-git",

		"vim-denops/denops.vim",

		"vigoux/notifier.nvim",
	}
	clone(appendPlugins)
	for _, p in ipairs(appendPlugins) do
		vim.opt.runtimepath:prepend(vim.fs.joinpath(basePath, p))
	end
end

Init()
