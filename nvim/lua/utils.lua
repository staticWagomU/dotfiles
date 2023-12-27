local M = {}

M.is_windows = vim.uv.os_uname().sysname == 'Windows_NT'

M.dpp_basePath = vim.fn.expand(vim.uv.os_homedir() .. '/.cache/dpp')

function M.usercmd(n, f, _opts)
  local opts = _opts or {}
  vim.api.nvim_create_user_command(n, f, opts)
end

M.autocmd = vim.api.nvim_create_autocmd

-- ref: https://github.com/monaqa/dotfiles/blob/8f7766f142693e47fbef80d6cc1f02fda94fac76/.config/nvim/lua/rc/abbr.lua
---@alias abbrrule {from: string, to: string, prepose?: string, prepose_nospace?: string, remove_trigger?: boolean}
---@param rules abbrrule[]
function M.make_abbrev(rules)
  -- 文字列のキーに対して常に0のvalue を格納することで、文字列の hashset を実現。
  ---@type table<string, abbrrule[]>
  local abbr_dict_rule = {}

  for _, rule in ipairs(rules) do
    local key = rule['from']
    if abbr_dict_rule[key] == nil then
      abbr_dict_rule[key] = {}
    end
    table.insert(abbr_dict_rule[key], rule)
  end

  for key, rules_with_key in pairs(abbr_dict_rule) do
    ---コマンドラインが特定の内容だったら、それに対応する値を返す。
    ---@type table<string, string>
    local d = {}

    for _, rule in ipairs(rules_with_key) do
      local required_pattern = rule['from']
      if rule['prepose_nospace'] ~= nil then
        required_pattern = rule['prepose_nospace'] .. required_pattern
      elseif rule['prepose'] ~= nil then
        required_pattern = rule['prepose'] .. ' ' .. required_pattern
      end
      d[required_pattern] = rule['to']
    end

    vim.cmd(([[
				cnoreabbrev <expr> %s (getcmdtype()==# ":") ? get(%s, getcmdline(), %s) : %s
				]]):format(key, vim.fn.string(d), vim.fn.string(key), vim.fn.string(key)))
  end
end

---@param opts table
---@param desc string
---@return table
function M.addDesc(opts, desc)
  local new_opts = vim.deepcopy(opts)
  new_opts.desc = desc
  return new_opts
end

---@alias optsTable {noremap?: boolean, silent?: boolean, expr?: boolean, script?: boolean, nowait?: boolean, buffer?: boolean, unique?: boolean, desc?: string}
---@alias keymaps table | string | function
---@param mode string | string[]
---@param opts optsTable
---@param keymaps keymaps[]
---@return nil
function M.setKeymaps(mode, opts, keymaps)
  -- 同じモードで複数のマッピングを設定するときに楽できるよ
  --
  -- 例: 文字列の場合、
  -- setKeymaps('n', {noremap = true}, {
  --  { '<Cr>', [[<Esc><Cmd>call ddu#ui#do_action('itemAction')<CR>]], 'exec item action' },
  --  ...
  -- })
  -- ↓
  -- vim.keymap.set('i', '<Cr>',[[<Esc><Cmd>call ddu#ui#do_action('itemAction')<CR>]] , { noremap = true, desc = 'exec item action' })
  --
  --
  -- 例: 関数の場合、
  -- setKeymaps('i', {noremap = true}, {
  --  {
  --   '<Cr>',
  --   function()
  --    vim.cmd.stopinsert()
  --    require('conf.ddu.helper')['do_action']('closeFilterWindow')
  --   end,
  --   'close filter window',
  --  },
  --  ...
  -- })
  -- ↓
  -- vim.keymap.set('i', '<Cr>', function()
  --  vim.cmd.stopinsert()
  --  require('conf.ddu.helper')['do_action']('closeFilterWindow')
  -- end, { noremap = true, desc = 'close filter window' })
  --
  --
  -- 例:
  -- setKeymaps('n', {noremap = true}, {
  --  { '<Cr>', { 'conf.ddu.helper.do_action', 'itemAction' }, 'exec item action' },
  --  ...
  -- })
  -- ↓
  -- vim.keymap.set('n', '<Cr>', function()
  --  require('conf.ddu.helper')['do_action']('itemAction')
  -- end, { noremap = true, desc = 'exec item action' })
  --
  local keymap = vim.keymap.set
  for _, k in ipairs(keymaps) do
    local key, action, desc = k[1], k[2], k[3]

    if type(action) == 'string' then
      keymap(mode, key, action, M.addDesc(opts, desc))
    end

    if type(action) == 'function' then
      keymap(mode, key, function()
        action()
      end, M.addDesc(opts, desc))
    end

    if type(action) == 'table' then
      local module = M.split(table.remove(action, 1), '.')
      local f = table.remove(module, #module)
      local path = table.concat(module, '.')

      if #action == 0 then
        keymap(mode, key, function()
          require(path)[f]()
        end, M.addDesc(opts, desc))
      else
        -- argsは、actionの2番目以降全ての要素を指す
        keymap(mode, key, function()
          ---@diagnostic disable-next-line: deprecated
          local arg1, arg2 = unpack(action)
          require(path)[f](arg1, arg2)
        end, M.addDesc(opts, desc))
      end
    end
  end
end

---@param str string
---@param delimiter string
---@return string[]
function M.split(str, delimiter)
  local result = {}
  local pattern = string.format('([^%s]+)', delimiter)
  ---@diagnostic disable-next-line: discard-returns
  str:gsub(pattern, function(token)
    table.insert(result, token)
  end)
  return result
end

return M
