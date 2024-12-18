return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    ---@diagnostic disable-next-line: missing-fields
    configs.setup({
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = { 'c', 'lua', 'javascript', 'rust', 'vimdoc', 'typescript', 'python', 'jsdoc', 'go' },
      indent = {
        enable = true,
      },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
