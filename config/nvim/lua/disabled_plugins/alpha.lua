return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require 'alpha.themes.dashboard'

      local banner = {
        "                                                    ",
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                    ",
      }

      dashboard.section.header.val = banner

      dashboard.section.buttons.val = {
        dashboard.button("n", " New file", ":enew<CR>"),
        dashboard.button("t", " Telescope", ":Telescope<CR>"),
        dashboard.button("f", " Find file", ":Telescope find_files<CR>"),
--        dashboard.button("e", " File browser", ":e ./<CR>"),
        dashboard.button("d", " Dotfiles", ":lcd ~/dotfiles<CR>:Telescope find_files<CR>"),
        dashboard.button("a", " Nvim Config Telescope", ":lcd ~/dotfiles/config/nvim<CR>:Telescope find_files<CR>"),
        dashboard.button("s", " Nvim Config Fern", ":lcd ~/dotfiles/config/nvim<CR><cmd>Fern . -drawer <CR>"),
        dashboard.button("rw", " Recent written files", "<cmd>RecentWrittenFiles<CR>"),
        dashboard.button("ru", " Recent used files", "<cmd>RecentUsedFiles<CR>"),
        dashboard.button("l", " Lazy", "<cmd>Lazy<CR>"),
        dashboard.button("q", " Exit", ":qa<CR>"),
      }

      require("alpha").setup(dashboard.config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "  Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end
  },
}
