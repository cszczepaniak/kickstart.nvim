-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Custom keymaps
vim.keymap.set('n', 'L', 'f(%f.a<CR><esc>')
vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('n', '[f', '<cmd>cprevious<CR>', { desc = 'Previous quick[f]ix item' })
vim.keymap.set('n', ']f', '<cmd>cnext<CR>', { desc = 'Next quick[f]ix item' })

-- Global settings
vim.cmd 'set textwidth=100'
vim.cmd 'set exrc'

return {
  {
    'cszczepaniak/bananasplit',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>fl', '<cmd>ArgWrap<CR>', {})
      require('nvim-treesitter.configs').setup {
        bananasplit = {
          enable = true,
          keymaps = {
            split = '<leader>fl',
          },
          argwrap_fallback = true,
          auto_format = true,
        },
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'FooSoft/vim-argwrap',
      'stevearc/conform.nvim',
    },
  },
  { 'nvim-treesitter/playground' },
  {
    'vim-test/vim-test',
    config = function()
      vim.cmd "let test#strategy = 'toggleterm'"
      vim.api.nvim_set_keymap('n', '<leader>tn', '<cmd>TestNearest<CR>', { desc = 'Run the [n]earest [t]est' })
      vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>TestFile<CR>', { desc = 'Run the [t]ests in this [f]ile' })
    end,
  },
  -- Adds :GBrowse command to open the current selection on GitHub
  {
    'tpope/vim-rhubarb',
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup()
      local terminal = require('toggleterm.terminal').Terminal
      local lazygit = terminal:new { direction = 'float', cmd = 'lazygit', hidden = true }

      vim.api.nvim_create_user_command('LazyGitToggle', function()
        lazygit:toggle()
      end, {})
      vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>LazyGitToggle<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aS'] = '@statement.outer',
              ['at'] = '@class.outer',
              ['it'] = '@class.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['aF'] = '@call.outer',
              ['iF'] = '@call.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['iC'] = '@conditional.inner',
              ['aC'] = '@conditional.outer',
              ['ae'] = '@element.outer',
              ['ie'] = '@element.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>fa'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>fA'] = '@parameter.inner',
            },
          },
        },
      }
    end,
  },
}
