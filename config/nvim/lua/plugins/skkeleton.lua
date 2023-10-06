vim.g["g:skkeleton#debug"] = 1
return {
  {
    "vim-skk/skkeleton",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/ddc.vim",
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsPluginPost:skkeleton",
        callback = function()
          local jisyo_path = function(name)
            local dictdir = vim.fs.joinpath(require("lazy.core.config").options.root, "dict")
            return vim.fs.joinpath(dictdir, name)
          end

          vim.fn["skkeleton#config"]({
            eggLikeNewline     = true,
            globalDictionaries = {
              "~/skk/SKK-JISYO.L", -- windowsでうまく読みこめないので、絶対パスで指定
              jisyo_path("SKK-JISYO.L"),
              jisyo_path("SKK-JISYO.hukugougo"),
              jisyo_path("SKK-JISYO.mazegaki"),
              jisyo_path("SKK-JISYO.propernoun"),
              jisyo_path("SKK-JISYO.station"),
            },
          })
          vim.fn["skkeleton#register_kanatable"]("rom", {
            [ [[z\<Space>]] ] = { [[\u3000]], '' },
          })
        end
      })
      vim.keymap.set({ "i", "c", "t" }, "<C-j>", "<Plug>(skkeleton-toggle)")
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
  },
}
