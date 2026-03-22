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
    config = function() vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Open git status' }) end,
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
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      dapui.setup()

      -- Python debugger setup via uv
      require('dap-python').setup 'uv'
      require('dap-python').test_runner = 'pytest'

      -- Auto-open only while you are setting things up
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end

      -- Breakpoint sign
      vim.fn.sign_define('DapBreakpoint', {
        text = '●',
        texthl = 'DiagnosticError',
        linehl = '',
        numhl = '',
      })

      -- Add your own project-specific config
      table.insert(dap.configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'FastAPI: uvicorn',
        module = 'uvicorn',
        args = {
          'app.main:app', -- change this per project
          '--host',
          '127.0.0.1',
          '--port',
          '8000',
        },
        console = 'integratedTerminal',
        cwd = '${workspaceFolder}',
        justMyCode = true,
        -- logToFile = true, -- enable only while troubleshooting
      })

      -- Optional plain Python sanity config
      table.insert(dap.configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'Python: current file',
        program = '${file}',
        console = 'integratedTerminal',
        cwd = '${workspaceFolder}',
        justMyCode = true,
      })

      -- Keymaps
      vim.keymap.set('n', '<F5>', function() dap.continue() end)
      vim.keymap.set('n', '<F10>', function() dap.step_over() end)
      vim.keymap.set('n', '<F11>', function() dap.step_into() end)
      vim.keymap.set('n', '<F12>', function() dap.step_out() end)
      vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end)
      vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end)
      vim.keymap.set('n', '<leader>du', function() dapui.toggle() end)
      vim.keymap.set('n', '<leader>dc', function() dapui.close() end)
      vim.keymap.set('n', '<leader>dq', function() dap.terminate() end)
      vim.keymap.set('n', '<leader>dpr', function() require('dap-python').test_method() end)
    end,
  },
}
