return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 25,
        keymap = {
          accept = '<C-y>',
        },
      },
    })
  end,
}