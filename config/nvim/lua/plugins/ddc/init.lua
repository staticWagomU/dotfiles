function _G.CommandlinePre(mode) 
  vim.b["prev_buffer_config"] = vim.fn["ddc#custom#get_buffer"]()
  if mode == ":" then
    vim.fn["ddc#custom#patch_buffer"]("sourceOptions", { _ = {keywordPattern = "[0-9a-zA-Z_:#-]*", minAutoCompleteLength = 2, }})
  end

  vim.api.nvim_create_autocmd("User", {
      pattern = "DDCCmdlineLeave",
      callback = function()
        if vim.fn.exists("b:prev_buffer_config") then
          vim.fn["ddc#custom#set_buffer"](vim.b["prev_buffer_config"])
          vim.b["prev_buffer_config"] = nil
        end
      end,
      once = true,
    })

  vim.fn["ddc#enable_cmdline_completion"]()
end

return {
  "Shougo/ddc.vim",
  dependencies = {
    "vim-denops/denops.vim",
    "Shougo/pum.vim",
    "Shougo/ddc-ui-pum",
    -- source
    "LumaKernel/ddc-source-file",
    "Shougo/ddc-source-around",
    "Shougo/ddc-source-cmdline",
    "Shougo/ddc-source-cmdline-history",
    "Shougo/ddc-source-copilot",
    "Shougo/ddc-source-input",
    "Shougo/ddc-source-mocword",
    "Shougo/ddc-source-nvim-lsp",
    "Shougo/ddc-source-rg",
    "Shougo/ddc-source-shell",
    "Shougo/ddc-source-shell-native",
    "matsui54/ddc-buffer",
    "uga-rosa/ddc-source-nvim-lua",
    -- filter
    "Shougo/ddc-filter-converter_remove_overlap",
    "Shougo/ddc-filter-matcher_head",
    "Shougo/ddc-filter-matcher_length",
    "Shougo/ddc-filter-matcher_prefix",
    "Shougo/ddc-filter-sorter_head",
    "Shougo/ddc-filter-sorter_rank",
  },
  config = function()
    -- keymaps
    vim.keymap.set({"i", "c"}, "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
    vim.keymap.set({"i", "c"}, "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
    vim.keymap.set({"i", "c"}, "<C-e>", function()
      if vim.fn["ddc#visible"]() then
        return vim.fn["ddc#hide"]("Manual")
      else
        return "<End>"
      end
    end, { remap = true })
    vim.keymap.set({"i", "c"}, "<C-l>", function()
      return vim.fn["ddc#map#manual_complete"]()
    end, { expr = true, replace_keycodes = false, desc="Refresh the completion" })
    vim.keymap.set({"n", "x"}, ":", "<Cmd>call v:lua.CommandlinePre(':')<CR>:")
    vim.keymap.set({"n"}, "?", "<Cmd>call v:lua.CommandlinePre('/')<CR>?")

    -- options
    vim.fn["pum#set_option"]({
      auto_confirm_time = 3000,
      auto_select = false,
      horizontal_menu = false,
      max_width = 80,
      offset_cmdcol = 0,
      padding = false,
      preview = true,
      preview_width = 80,
      reversed = false,
      use_complete = true,
      use_setline = false,
    })
    vim.fn["pum#set_local_option"]("c",{ { horizontal_menu = false, }, })
    vim.fn["ddc#custom#load_config"](vim.fs.joinpath(require("utils").plugins_path, "ddc", "ddc.ts"))
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn["ddc#custom#load_config"](vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "plugins", "ddc", "ddc.ts"))
    vim.fn["ddc#enable"]({context_filetype = "treesitter"})
    vim.fn["ddc#enable_terminal_completion"]()
  end
}
