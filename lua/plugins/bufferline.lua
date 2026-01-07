
return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({

      vim.api.nvim_set_hl(0, "BufferLineFill", {
        bg = "#111111",
      }),

      options = {

        offsets = {
          {
            filetype = "NvimTree",
            text = "",
            text_align = "center",
            separator = false,
            padding = 1,
            highlight = "BufferLineOffsetTitle",
          },
        },

        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,

      },
    })
    
    -- Set highlight after bufferline setup
    vim.api.nvim_set_hl(0, "BufferLineOffsetTitle", {
      fg = "#111111",
      bg = "#111111",
      bold = true,
      italic = false,
    })
    
    -- Also set it when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "BufferLineOffsetTitle", {
          fg = "#111111",
          bg = "#111111",
          bold = true,
          italic = false,
        })
      end,
    })
  end,
}

