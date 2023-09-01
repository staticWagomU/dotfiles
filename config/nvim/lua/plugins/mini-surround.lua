local function getchar()
  return vim.fn.nr2char(vim.fn.getchar())
end

local function japanize_bracket(dict, callbacks)
  return function()
    local char = getchar()

    if callbacks[char] then
      return callbacks[char](dict)
    end
    if dict[char] then
      return dict[char]
    end

    error("j" .. char .. " is unsupported")
  end
end

local BRACKETS = {
  ["{"] = {
    input = { "%b{}", "^.().*().$" },
    output = { left = "{", right = "}" },
  },
  ["}"] = {
    input = { "%b{}", "^.%{().*()%}.$" },
    output = { left = "{{", right = "}}" },
  },
  ["("] = {
    input = { "%b()", "^.().*().$" },
    output = { left = "(", right = ")" },
  },
  [")"] = {
    input = { "%b()", "^.%(().*()%).$" },
    output = { left = "((", right = "))" },
  },
  ["["] = {
    input = { "%b[]", "^.().*().$" },
    output = { left = "[", right = "]" },
  },
  ["]"] = {
    input = { "%b[]", "^.%[().*()%].$" },
    output = { left = "[[", right = "]]" },
  },
  ["<"] = {
    input = { "%b<>", "^.().*().$" },
    output = { left = "<", right = ">" },
  },
  [">"] = {
    input = { "%b[]", "^.<().*()>.$" },
    output = { left = "<<", right = ">>" },
  },
}
local recipes = vim.tbl_extend("force", {}, BRACKETS)

recipes[" "] = {
  input = function()
    -- vi<Space>[ to select region without spaces, tabs, and \n
    local char = getchar()
    local ok, input = pcall(function()
      return BRACKETS[char].input
    end)
    if not ok or not input then
      return
    end
    local location = string.gsub(input[2], [[%(%)%.%*%(%)]], "[\n\t ]*().-()[\n\t ]*")
    return { input[1], location }
  end,
}

recipes["j"] = {
  input = japanize_bracket({
    ["("] = { "（().-()）" },
    ["{"] = { "｛().-()｝" },
    ["["] = { "「().-()」" },
    ["]"] = { "『().-()』" },
  }, {
    b = function(dict)
      local ret = {}
      for _, v in pairs(dict) do
        table.insert(ret, v)
      end
      return { ret }
    end,
  }),
  output = japanize_bracket({
    ["("] = { left = "（", right = "）" },
    ["{"] = { left = "｛", right = "｝" },
    ["["] = { left = "「", right = "」" },
    ["]"] = { left = "『", right = "』" },
  }, {}),
}
return {
  "echasnovski/mini.surround",
  keys = { { "s", "<Nop>", mode = "" } },
  config = function()
    --[=[
      Examples
        saiw[ surrounds inner word with [] and saiw] surrounds inner word with [[]]
        Similar behaviors occurs with (){}<>

        saiwj[ surrounds inner word with 「」
        srj[j] replaces 「」 with 『』
      ]=]

    local t = {
      input = { "<(%w-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- from https://github.com/echasnovski/mini.surround/blob/14f418209ecf52d1a8de9d091eb6bd63c31a4e01/lua/mini/surround.lua#LL1048C13-L1048C72
      output = function()
        local emmet = require("mini.surround").user_input("Emmet")
        if not emmet then
          return nil
        end
        return require("emmet").totag(emmet)
      end,
    }
    require("mini.surround").setup({
        n_lines = 100,
        mappings = {
          find = "st",
          find_left = "sT",
          highlight = "sH",
        },
        custom_surroundings = vim.tbl_extend("force", recipes, {
            t = t,
          }),
      })
  end,
}
