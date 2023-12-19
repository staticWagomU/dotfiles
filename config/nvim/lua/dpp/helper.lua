local M = {}

M.basePath = vim.fn.expand(vim.uv.os_homedir() .. '/.cache/dpp')

M.tsPath = vim.fs.joinpath(vim.fn.stdpath("config"), "rc", "dpp", "dpp.ts")

return M
