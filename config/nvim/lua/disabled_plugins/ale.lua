return {
  "dense-analysis/ale",
  ft = {
    "javascript",
    "typescript",
    "astro",
    "javascriptreact",
    "javascript.jsx",
    "typescriptreact",
    "typescript.tsx",
    "svelte",
    "vue",
  },
  config = function()
    -- vim.b.ale_fixers = {'prettier', 'eslint'}
    vim.cmd[[
    let b:ale_fixers = ['prettier', 'eslint']
    ]]
  end,
}
