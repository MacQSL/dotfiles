-- LSP
return {
  'neovim/nvim-lspconfig',
  cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'saghen/blink.cmp' },
    -- { 'hrsh7th/cmp-nvim-lsp' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
  },
  init = function()
    -- Reserve a space in the gutter
    -- This will avoid an annoying layout shift in the screen
    vim.opt.signcolumn = 'yes'
  end,
  config = function()
    -- local lsp_defaults = require('lspconfig').util.default_config

    -- -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- -- This should be executed before you configure any language server
    -- lsp_defaults.capabilities =
    --   vim.tbl_deep_extend('force', lsp_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- LspAttach is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = { buffer = event.buf }

        -- Hover
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)

        -- Code actions
        vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

        -- View diagnostics
        vim.keymap.set('n', '<leader>vd', '<cmd> lua vim.diagnostic.open_float()<cr>', opts)

        -- -- Go to definition, type definition, and references
        -- vim.keymap.set('n', 'gv', function() require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' }) end)
        -- vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions() end, opts)
        -- vim.keymap.set('n', 'gt', function() require('telescope.builtin').lsp_type_definitions() end, opts)
        -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)

        -- Signature help
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

        -- Rename
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
      end,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    ---@diagnostic disable-next-line: missing-fields
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls' },
      handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name) require('lspconfig')[server_name].setup({ capabilities = capabilities }) end,
        ---                 ---
        --- CUSTOM HANDLERS ---
        ---                 ---
        eslint = function() require('lspconfig').eslint.setup({ capabilities = capabilities }) end,

        -- Lua language server custom handler
        lua_ls = function()
          require('lspconfig').lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                telemetry = {
                  enable = false,
                },
              },
            },
            on_init = function(client)
              local join = vim.fs.joinpath
              local path = client.workspace_folders[1].name

              -- Don't do anything if there is project local config
              if vim.uv.fs_stat(join(path, '.luarc.json')) or vim.uv.fs_stat(join(path, '.luarc.jsonc')) then
                return
              end

              -- Apply neovim specific settings
              local runtime_path = vim.split(package.path, ';')
              table.insert(runtime_path, join('lua', '?.lua'))
              table.insert(runtime_path, join('lua', '?', 'init.lua'))

              local nvim_settings = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  version = 'LuaJIT',
                  path = runtime_path,
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    -- Make the server aware of Neovim runtime files
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath('config'),
                  },
                },
              }

              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, nvim_settings)
            end,
          })
        end,
      },
    })
  end,
}
