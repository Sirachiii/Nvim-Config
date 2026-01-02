
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    require("nvim-tree").setup({
      sync_root_with_cwd = true,
      respect_buf_cwd = true,

      diagnostics = { enable = false },

      view = {
        width = 30,
        side = "left",
        signcolumn = "yes",
      },

      renderer = {
        root_folder_label = false,
        highlight_git = "name",
        highlight_opened_files = "none",
        special_files = { "README.md", "Makefile" },

        indent_markers = {
          enable = true,
          inline_arrows = false,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },

        icons = {
          webdev_colors = true,
          git_placement = "after",
          padding = " ", -- space between files and left
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
          },
          glyphs = {
            git = {
              unstaged  = "",
              staged    = "✓",
            },
          },
        },
      },

      git = {
        enable = true,
        ignore = false,
      },

      filters = { dotfiles = false },

      actions = { open_file = { quit_on_open = false } },
    })

    -- Set nvim-tree background
    local bg = "#1e1e2e"
    vim.api.nvim_set_hl(0, "NvimTreeNormal",       { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC",     { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer",  { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = bg, bg = bg })

    -- Git highlight colors
    vim.api.nvim_set_hl(0, "NvimTreeGitDirty",   { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "NvimTreeGitNew",     { fg = "#9ece6a" })
    vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = "#f7768e" })
    vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#2a2a37" })
  end,
}

