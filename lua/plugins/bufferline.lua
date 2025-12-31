
return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local bufferline = require("bufferline")

    -- basic setup
    bufferline.setup {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thick",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
      },
    }

    -- fix colors & fake bottom border after colorscheme loads
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- get colors
        local statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })
        local neotree_border = vim.api.nvim_get_hl(0, { name = "NeoTreeFloatBorder" })
            or vim.api.nvim_get_hl(0, { name = "WinSeparator" })

        -- bufferline background matches statusline
        vim.api.nvim_set_hl(0, "BufferLineFill", {
          bg = statusline.bg,
        })

        -- separators act as bottom border
        vim.api.nvim_set_hl(0, "BufferLineSeparator", {
          fg = neotree_border.fg,
          bg = statusline.bg,
        })

        vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", {
          fg = neotree_border.fg,
          bg = statusline.bg,
        })

        -- optional: selected/unselected buffers
        vim.api_set_hl(0, "BufferLineBackground", { bg = statusline.bg })
        vim.api_set_hl(0, "BufferLineBufferSelected", { bg = statusline.bg })
      end,
    })
  end,
}

