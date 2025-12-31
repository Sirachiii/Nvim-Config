
-- lua/extras/bufferSeparator.lua

local M = {}

-- Neo-tree horizontal line color
vim.api.nvim_set_hl(0, "NeoTreeBorderLine", { bg = "#1c1c24" })

-- Keep track of the border window
local border_win = nil

-- Function to check if bufferline window exists
local function bufferline_visible()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    -- adjust this to match your bufferline plugin name if needed
    if bufname:match(".*bufferline.*") then
      return true
    end
  end
  return false
end

-- Create/update the horizontal border
local function update_bufferline_border()
  if not bufferline_visible() then
    -- remove border if it exists
    if border_win and vim.api.nvim_win_is_valid(border_win) then
      vim.api.nvim_win_close(border_win, true)
      border_win = nil
    end
    return
  end

  -- resize if it already exists
  if border_win and vim.api.nvim_win_is_valid(border_win) then
    vim.api.nvim_win_set_height(border_win, 1)
    return
  end

  -- create a new 1-line window below current window (bufferline)
  vim.api.nvim_command("belowright 1split")
  border_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(border_win, 1)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
  vim.api.nvim_win_set_option(border_win, "winhl", "Normal:NeoTreeBorderLine")
  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "modifiable", false)
  vim.api.nvim_win_set_option(border_win, "winfixheight", true)
  vim.api.nvim_command("wincmd p") -- go back to previous window
end

-- Autocmds to keep it updated
vim.api.nvim_create_autocmd({ "VimResized", "BufWinEnter", "WinEnter" }, {
  callback = update_bufferline_border,
})

-- expose update function if needed
M.update = update_bufferline_border

return M
