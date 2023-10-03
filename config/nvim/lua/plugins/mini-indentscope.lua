return {
  "echasnovski/mini.indentscope",
  version = "*",
  opts = {
    -- Draw options
    draw = {
      -- Delay (in ms) between event and start of drawing scope indicator
      delay = 100,
      priority = 2,
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Textobjects
      object_scope = 'ii',
      object_scope_with_border = 'ai',

      -- Motions (jump to respective border line; if not present - body line)
      goto_top = '[i',
      goto_bottom = ']i',
    },

    -- Options which control scope computation
    options = {
      border = 'both',
      indent_at_cursor = true,
      try_as_border = false,
    },

    symbol = '┃',
  }
}
