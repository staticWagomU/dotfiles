local M = {}

M.is_windows = vim.uv.os_uname().version:match("Windows") == not nil

M.dpp_basePath = vim.fn.expand(vim.uv.os_homedir() .. "/.cache/dpp")

function M.split(str, sep)
	if sep == nil then return {} end
	local t = {}
	i=1
	for s in string.gmatch(str, "([^".. sep .."]+)") do
		t[i] = s
		i = i + 1
	end

	return t
end


return M
