vim.o.relativenumber = true
vim.o.mouse = ''
vim.o.termguicolors = true
vim.o.list = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.encoding = 'utf-8'
vim.o.colorcolumn = '100'
vim.g.skip_ts_context_commentstring_module = true

vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('x', '<leader>p', '"_dp')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Quickfix next' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Quickfix previous' })

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local extra_servers = {
      gopls = {},
      pyright = {},
      ts_ls = {},
      html = {},
      cssls = {},
      tailwindcss = {},
      jsonls = {},
    }
    for name, server in pairs(extra_servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end

    local ok_mti, mti = pcall(require, 'mason-tool-installer')
    if ok_mti then
      mti.setup {
        ensure_installed = {
          'gopls',
          'pyright',
          'typescript-language-server',
          'html-lsp',
          'css-lsp',
          'tailwindcss-language-server',
          'json-lsp',
          'stylua',
          'prettier',
          'eslint_d',
          'black',
          'isort',
        },
      }
    end

  end,
})

return {}
