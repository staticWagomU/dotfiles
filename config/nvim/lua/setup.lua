if require('utils').is_windows and vim.g['useShared'] == true then
  vim.g['denops_server_addr'] = '127.0.0.1:32123'
end

local basePath = vim.fs.joinpath(require('utils').dpp_basePath, 'repos', 'github.com')

local function clone(plugins)
  for _, plugin in ipairs(plugins) do
    local repoPath = vim.fs.joinpath(basePath, plugin)
    if not vim.loop.fs_stat(repoPath) then
      vim.fn.system {
        'git',
        'clone',
        'https://github.com/' .. plugin .. '.git',
        repoPath,
      }
    end
  end
end

local function Init()
  local prependPlugins = {
    'Shougo/dpp.vim',
  }
  for _, p in ipairs(prependPlugins) do
    vim.opt.runtimepath:prepend(vim.fs.joinpath(basePath, p))
  end
  clone(prependPlugins)
  local appendPlugins = {
    'Shougo/dpp-ext-lazy',
    'Shougo/dpp-ext-installer',
    'Shougo/dpp-ext-packspec',
    'Shougo/dpp-ext-toml',
    'Shougo/dpp-ext-local',
    'Shougo/dpp-protocol-git',

    'vim-denops/denops.vim',

    'vigoux/notifier.nvim',
    'bluz71/vim-nightfly-colors',
  }
  clone(appendPlugins)
  for _, p in ipairs(appendPlugins) do
    vim.opt.runtimepath:prepend(vim.fs.joinpath(basePath, p))
  end
  require('notifier').setup {}

  -- -------------------------------------
  -- colorscheme settings
  -- -------------------------------------
  vim.cmd.colorscheme('nightfly')
  vim.g.nightflyCursorColor = true
  vim.g.nightflyNormalFloat = true
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'single',
  })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
    border = 'single',
  })
  vim.diagnostic.config { float = { border = 'single' } }
  vim.g.colorPalette = require('nightfly').palette
end

Init()
