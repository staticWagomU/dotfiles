-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "C:\\Users\\hayasi\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?.lua;C:\\Users\\hayasi\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\hayasi\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\hayasi\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\hayasi\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip.git"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer.git"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc.git"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline.git"
  },
  ["cmp-git"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-git",
    url = "https://github.com/petertriho/cmp-git.git"
  },
  ["cmp-mocword"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-mocword",
    url = "https://github.com/yutkat/cmp-mocword.git"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp.git"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol.git"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help.git"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-path",
    url = "https://github.com/hrsh7th/cmp-path.git"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-spell",
    url = "https://github.com/f3fora/cmp-spell.git"
  },
  cmp_luasnip = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip.git"
  },
  ["iceberg.vim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25pluginconfig/iceberg\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\iceberg.vim",
    url = "https://github.com/cocopon/iceberg.vim.git"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim.git"
  },
  ["lspsaga.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25pluginconfig/lspsaga\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim.git"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25pluginconfig/lualine\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim.git"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim.git"
  },
  ["mason.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23pluginconfig/mason\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason.nvim",
    url = "https://github.com/williamboman/mason.nvim.git"
  },
  ["modes.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23pluginconfig/modes\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\modes.nvim",
    url = "https://github.com/mvllow/modes.nvim.git"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26pluginconfig/nvim-cmp\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp.git"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig.git"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!pluginconfig/nvim-treesitter\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter.git"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons.git"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim.git"
  },
  ["pgmnt.vim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\pgmnt.vim",
    url = "https://github.com/cocopon/pgmnt.vim.git"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim.git"
  },
  ["telescope-changes.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-changes.nvim",
    url = "https://github.com/LinArcX/telescope-changes.nvim.git"
  },
  ["telescope-file-browser.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim.git"
  },
  ["telescope-fzy-native.nvim"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15fzy_native\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-fzy-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzy-native.nvim.git"
  },
  ["telescope-github.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-github.nvim",
    url = "https://github.com/nvim-telescope/telescope-github.nvim.git"
  },
  ["telescope-heading.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-heading.nvim",
    url = "https://github.com/crispgm/telescope-heading.nvim.git"
  },
  ["telescope-rg.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-rg.nvim",
    url = "https://github.com/nvim-telescope/telescope-rg.nvim.git"
  },
  ["telescope-smart-history.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim.git"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim.git"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim.git"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27pluginconfig/telescope\frequire\0" },
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim.git"
  },
  ["toggleterm.nvim"] = {
    loaded = true,
    path = "C:\\Users\\hayasi\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim.git"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!pluginconfig/nvim-treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: telescope-file-browser.nvim
time([[Config for telescope-file-browser.nvim]], true)
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0", "config", "telescope-file-browser.nvim")
time([[Config for telescope-file-browser.nvim]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23pluginconfig/mason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: iceberg.vim
time([[Config for iceberg.vim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25pluginconfig/iceberg\frequire\0", "config", "iceberg.vim")
time([[Config for iceberg.vim]], false)
-- Config for: modes.nvim
time([[Config for modes.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23pluginconfig/modes\frequire\0", "config", "modes.nvim")
time([[Config for modes.nvim]], false)
-- Config for: telescope-fzy-native.nvim
time([[Config for telescope-fzy-native.nvim]], true)
try_loadstring("\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15fzy_native\19load_extension\14telescope\frequire\0", "config", "telescope-fzy-native.nvim")
time([[Config for telescope-fzy-native.nvim]], false)
-- Config for: lspsaga.nvim
time([[Config for lspsaga.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25pluginconfig/lspsaga\frequire\0", "config", "lspsaga.nvim")
time([[Config for lspsaga.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26pluginconfig/nvim-cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27pluginconfig/telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25pluginconfig/lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
