
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  priority = 1000,
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
    { '<leader>i', ':Neotree reveal<CR>zR', desc = 'NeoTree expand all', silent = true },
  },
  opts = {
    window = {
      width = 30, -- Set the width of the neo-tree window
      position = "left", -- Position the window on the left (or "right", "top", "bottom", "float")
      statusline = false,
    },
    filesystem = {
      follow_current_file = true, -- Automatically reveal the current file in the tree
      filtered_items = {
        hide_dotfiles = false, -- Show dotfiles
        hide_gitignored = false, -- Show gitignored files
      },
    },
    buffers = {
      follow_current_file = true,
    },
  },
}
