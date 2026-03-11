---@module 'lazy'
---@type LazySpec
return {
  { import = 'kickstart.plugins.debug' },
  { import = 'kickstart.plugins.indent_line' },
  { import = 'kickstart.plugins.autopairs' },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        json = { 'jsonlint' },
        javascript = { 'eslint' },
        typescript = { 'eslint' },
      }
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then lint.try_lint() end
        end,
      })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    config = function()
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'
      vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Harpoon add file' })
      vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'Harpoon menu' })
      vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'Harpoon file 4' })
    end,
  },

  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Open git status' })
    end,
  },

  { 'ThePrimeagen/vim-be-good' },
  {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function() require('ts_context_commentstring').setup {} end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      require('ufo').setup {}
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = {},
  },
  { 'sphamba/smear-cursor.nvim', opts = {} },
  { 'nvzone/typr', dependencies = { 'nvzone/volt' }, cmd = { 'Typr', 'TyprStats' }, opts = {} },
  { 'folke/zen-mode.nvim', opts = {} },
  { 'folke/twilight.nvim', opts = {} },
  {
    'olimorris/codecompanion.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    opts = {
      opts = { log_level = 'DEBUG' },
    },
  },
  {
    'folke/snacks.nvim',
    opts = {
      input = {},
      picker = {},
    },
  },
  {
    'nickjvandyke/opencode.nvim',
    version = '*',
    dependencies = {
      {
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require('opencode').snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
      local opencode = require 'opencode'
      vim.keymap.set({ 'n', 'x' }, '<leader>oa', function() opencode.ask('@this: ', { submit = true }) end, { desc = 'Opencode ask' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ox', function() opencode.select() end, { desc = 'Opencode select action' })
      vim.keymap.set({ 'n', 't' }, '<leader>ot', function() opencode.toggle() end, { desc = 'Opencode toggle' })
      vim.keymap.set({ 'n', 'x' }, '<leader>or', function() return opencode.operator '@this ' end, { desc = 'Opencode add range', expr = true })
      vim.keymap.set('n', '<leader>ol', function() return opencode.operator '@this ' .. '_' end, { desc = 'Opencode add line', expr = true })
      vim.keymap.set('n', '<leader>ou', function() opencode.command 'session.half.page.up' end, { desc = 'Opencode scroll up' })
      vim.keymap.set('n', '<leader>od', function() opencode.command 'session.half.page.down' end, { desc = 'Opencode scroll down' })
    end,
  },
}
