return {
  {
  "vim-skk/skkeleton",
  config = function(p)
    local path_join = require("utils").path_join
    local dictdir = path_join(vim.fs.dirname(p.dir), "dict")

    local skkeleton_init = function ()
      vim.fn["skkeleton#config"]({
        eggLikeNewline = true,
        globalDictionaries = {
          path_join(dictdir, "SKK-JISYO.L"),
          path_join(dictdir, "SKK-JISYO.assoc"),
          path_join(dictdir, "SKK-JISYO.emoji"),
          path_join(dictdir, "SKK-JISYO.edict"),
          path_join(dictdir, "SKK-JISYO.edict2"),
          path_join(dictdir, "SKK-JISYO.fullname"),
          path_join(dictdir, "SKK-JISYO.geo"),
          path_join(dictdir, "SKK-JISYO.hukugougo"),
          path_join(dictdir, "SKK-JISYO.mazegaki"),
          path_join(dictdir, "SKK-JISYO.propernoun"),
          path_join(dictdir, "SKK-JISYO.station"),
        },
      })
      vim.fn["skkeleton#register_kanatable"]("rom", {
          [ [[z\<Space>]] ] = {[[\u3000]], ''},
      })
    end
    vim.keymap.set({ "i", "c" }, "<C-J>", "<Plug>(skkeleton-enable)")

    vim.api.nvim_create_autocmd({ "User" }, {
      group = vim.api.nvim_create_augroup("skkeleton-initialize-pre", {}),
      callback = function()
        skkeleton_init()
      end,
      once = true,
    })
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
