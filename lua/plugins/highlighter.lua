
return {
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPost", -- lazy-load when opening a file
  config = function()
    require("colorizer").setup({
      "*", -- all files
      css = { css = true }, -- enable CSS parsing so it highlights things like `#fff`, `rgb()`
      html = { css = true },
    }, {
      mode = "background", -- colour block behind text
      tailwind = true,      -- optional if you use Tailwind classes
    })
  end,
}
