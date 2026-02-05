
return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
        stages = "slide",
        timeout = 3000,
        background_colour = "#141415",
    })
    vim.notify = require("notify")

    -- Reapply highlights after colorscheme loads
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- INFO
        vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "NotifyINFOTitle",  { fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "NotifyINFOIcon",   { fg = "#7aa2f7" })

        -- WARN
        vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#e0af68" })
        vim.api.nvim_set_hl(0, "NotifyWARNTitle",  { fg = "#e0af68", bold = true })

        -- ERROR
        vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#f7768e" })
        vim.api.nvim_set_hl(0, "NotifyERRORTitle",  { fg = "#f7768e", bold = true })
        vim.api.nvim_set_hl(0, "NotifyERRORIcon",   { fg = "#f7768e" })
      end
    })

    -- Force it once in case colorscheme was already loaded
    vim.cmd("doautocmd ColorScheme")
  end
}

