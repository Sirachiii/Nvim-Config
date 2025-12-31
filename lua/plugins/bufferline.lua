
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "thick", -- "thin" | "thick" | "slope"
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
        },
      }
    end,
  },
}

