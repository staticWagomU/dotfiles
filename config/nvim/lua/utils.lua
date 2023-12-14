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

function M.addDesc(opts, desc)
  local new_opts = vim.deepcopy(opts)
  new_opts.desc = desc
  return new_opts
end

return M
