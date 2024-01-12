return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', {})
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', {})
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', {})

      vim.keymap.set('n', '<leader>gs', ':Telescope git_status<CR>', {})
      vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', {})
      vim.keymap.set('n', '<leader>gl', ':Telescope git_commits<CR>', {})
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      -- This is your opts table
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            }
          }
        }
      }
      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
    end
  }
}
