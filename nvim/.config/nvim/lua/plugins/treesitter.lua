return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = { 'c', 'lua', 'javascript', 'rust', 'vimdoc', 'typescript', 'python', 'jsdoc', 'go' },
      ignore_install = {},
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
      diagnostics = { disable = { 'missing-fields' } },
    })
  end,
}
