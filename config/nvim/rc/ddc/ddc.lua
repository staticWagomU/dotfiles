-- lua_add {{{
local set_buffer = vim.fn['ddc#custom#set_buffer']
local get_buffer = vim.fn['ddc#custom#get_buffer']

local function commandline_post()
    if vim.b.prev_buffer_config then
        set_buffer(vim.b.prev_buffer_config)
        vim.b.prev_buffer_config = nil
    end
end

function commandline_pre()
    vim.b.prev_buffer_config = get_buffer()
    vim.api.nvim_create_autocmd("User", {
        group = utils.vimrc_augroup,
        pattern = "DDCCmdlineLeave",
        callback = function()
            commandline_post()
        end,
        once = true,
    })
    vim.fn['ddc#enable_cmdline_completion']()
end

-- }}

-- lua_source {{{

-- }}}

-- lua_post_update {{{
vim.fn['ddc#set_static_import_path']()
-- }}}
