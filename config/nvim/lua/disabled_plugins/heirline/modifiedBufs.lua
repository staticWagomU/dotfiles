---@return number
local function modifiedBufs()
    local cnt = 0
    for i = 1, vim.fn.bufnr("$") do
        if vim.fn.bufexists(i) == 1 and vim.fn.buflisted(i) == 1 and vim.fn.getbufvar(i, "buftype") == "" and
            vim.fn.filereadable(vim.fn.expand("#" .. i .. ":p")) and i ~= vim.fn.bufnr("%") and
            vim.fn.getbufvar(i, "&modified") == 1 then
            cnt = cnt + 1
        end
    end
    return cnt
end

return {
  provider = function ()
    return modifiedBufs()
  end,
  condition = modifiedBufs() ~= 0
}
