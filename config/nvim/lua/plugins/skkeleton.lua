return {
  {
  "vim-skk/skkeleton",
  config = function(p)
    vim.api.nvim_create_autocmd("User", {
      pattern = "DenopsPluginPost:skkeleton",
      callback = function()
        local dictdir = vim.fs.joinpath(vim.fs.dirname(p.dir), "dict")

        vim.fn["skkeleton#config"]({
          eggLikeNewline = true,
          globalDictionaries = {
            "~/skk/SKK-JISYO.L",
            {vim.fs.joinpath(dictdir, "SKK-JISYO.L"), "utf-8" },
            {vim.fs.joinpath(dictdir, "SKK-JISYO.hukugougo"), "utf-8" },
            {vim.fs.joinpath(dictdir, "SKK-JISYO.mazegaki"), "utf-8" },
            {vim.fs.joinpath(dictdir, "SKK-JISYO.propernoun"), "utf-8" },
            {vim.fs.joinpath(dictdir, "SKK-JISYO.station"), "utf-8" },
          },
        })
        vim.fn["skkeleton#register_kanatable"]("rom", {
            [ [[z\<Space>]] ] = {[[\u3000]], ''},
        })
      end
    })
    vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-toggle)")
  end
  },
  {
    "delphinus/skkeleton_indicator.nvim",
    depends = { "vim-skk/skkeleton" },
    opts = {
      alwaysShown = false,
    },
  },
  {
    "skk-dev/dict",
    cond = false,
  },
}
