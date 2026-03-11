---@module 'lazy'
---@type LazySpec
return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      {
        '<leader>pf',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find [P]roject [F]iles',
      },
      {
        '<leader>pg',
        function()
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local make_entry = require 'telescope.make_entry'
          local conf = require('telescope.config').values

          pickers
            .new({}, {
              prompt_title = 'Multi Grep',
              finder = finders.new_async_job {
                command_generator = function(prompt)
                  if not prompt or prompt == '' then return nil end
                  local pieces = vim.split(prompt, '  ')
                  local args = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }
                  if pieces[1] and pieces[1] ~= '' then
                    table.insert(args, '-e')
                    table.insert(args, pieces[1])
                  end
                  if pieces[2] and pieces[2] ~= '' then
                    table.insert(args, '-g')
                    table.insert(args, pieces[2])
                  end
                  return args
                end,
                entry_maker = make_entry.gen_from_vimgrep {},
              },
              previewer = conf.grep_previewer {},
              sorter = require('telescope.sorters').empty(),
            })
            :find()
        end,
        desc = 'Multi [P]attern [G]rep',
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', stop_after_first = true },
        css = { 'prettierd', stop_after_first = true },
        python = { 'black', 'isort' },
      },
    },
  },
  {
    'saghen/blink.cmp',
    opts = {
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local filetypes = {
        'bash',
        'c',
        'typescript',
        'javascript',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'css',
        'tsx',
        'go',
        'json',
      }

      vim.schedule(function()
        require('nvim-treesitter').install(filetypes)
      end)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  { 'folke/tokyonight.nvim', enabled = false },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        variant = 'auto',
        dark_variant = 'main',
        styles = {
          italic = false,
          transparency = false,
          bold = true,
        },
      }
      vim.cmd.colorscheme 'rose-pine'
    end,
  },
}
