if require('utils').is_windows then
	vim.g['denops#deno'] = os.getenv('USERPROFILE') .. '/.deno/bin/deno.exe'
end
vim.loader.enable()
require('setup')
require('dpp_vim')
require('options')
require('keymaps')
