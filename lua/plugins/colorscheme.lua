return {
  "vague-theme/vague.nvim",
  priority = 1000,
  config = function()
    require("vague").setup({
      -- transparent = true,  -- Enable transparent background
      -- style = {
      --   boolean = "none",
      --   number = "none",
      --   float = "none",
      --   error = "none",
      --   comments = "italic",
      --   conditionals = "none",
      --   functions = "none",
      --   headings = "bold",
      --   operators = "none",
      --   strings = "none",
      --   variables = "none",
      --   keywords = "none",
      -- },
    })
    vim.cmd.colorscheme("vague")
  end
}
