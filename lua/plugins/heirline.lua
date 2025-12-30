
local heirline = require('heirline')

-- Mode component
local mode = {
  provider = function()
    return " "..vim.fn.mode().." "
  end,
  hl = function()
    local mode_color = {
      n = "Red",
      i = "Green",
      v = "Blue",
      V = "Blue",
      c = "Yellow",
    }
    return { fg = mode_color[vim.fn.mode()] or "White", bold = true }
  end,
}

-- Filename component
local filename = {
  provider = function()
    return " " .. vim.fn.expand("%:t") .. " "
  end,
}

-- Assemble statusline
heirline.setup({
  statusline = {
    mode,
    filename,
  },
})
