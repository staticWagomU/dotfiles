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

local print_plugins_message = function()
  local footer_icon = "  "
  local total_plugins = vim.fn.luaeval("#vim.tbl_keys(packer_plugins)")

  return {
    footer_icon .. "neovim loaded " .. total_plugins .. " plugins"
  }

end

dashboard.section.header.val = banner
dashboard.section.footer.val = print_plugins_message

dashboard.section.buttons.val = {
  dashboard.button("n", " New file", ":enew<CR>"),
  dashboard.button("t", " Telescope", ":Telescope<CR>"),
  dashboard.button("f", " Find file", ":Telescope find_files<CR>"),
  dashboard.button("e", " File browser", ":lua require'lir.float'.toggle()<cr>"),
  dashboard.button("i", " Init.lua", ":cd ~/dotfiles/nvim/lua<CR>:lua require'lir.float'.toggle()<cr>"),
  dashboard.button("d", " Dotfiles", ":cd ~/dotfiles/<CR>:lua require'lir.float'.toggle()<cr>"),
  dashboard.button("u", " Update plugins", ":PackerSync<CR>"),
  dashboard.button("c", " Compile plugins", ":PackerCompile<CR>"),
  dashboard.button("q", " Exit", ":qa<CR>"),
}

require 'alpha'.setup(dashboard.config)
