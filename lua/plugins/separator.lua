
return {
  dir = vim.fn.stdpath("config") .. "/lua/custom",
  config = function()
    require('custom.separators').setup()
  end
}

