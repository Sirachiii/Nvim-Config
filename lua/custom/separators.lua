
-- lua/separator-lines/init.lua

local M = {}

-- Default configuration
M.config = {
  horizontal_char = "▂",
  vertical_char = "▌",
  horizontal_highlight = "Comment",
  vertical_highlight = "Comment",
}

-- Namespace for our virtual text
local ns_id = vim.api.nvim_create_namespace("separator_lines")

-- Function to draw horizontal separator below bufferline
local function draw_horizontal_separator()
  local bufnr = vim.api.nvim_get_current_buf()
  local width = vim.api.nvim_win_get_width(0)
  local separator = string.rep(M.config.horizontal_char, width)
  
  -- Clear previous separator
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  
  -- Add separator at line 1 (below bufferline which is typically at line 0)
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = {{separator, M.config.horizontal_highlight}},
    virt_text_pos = "overlay",
    hl_mode = "combine",
  })
end

-- Function to draw vertical separator next to nvim-tree
local function draw_vertical_separator()
  -- Find nvim-tree window
  local tree_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "NvimTree" then
      tree_win = win
      break
    end
  end
  
  if not tree_win then return end
  
  -- Get the width of nvim-tree window
  local tree_width = vim.api.nvim_win_get_width(tree_win)
  
  -- Find the window next to nvim-tree (usually the main editing window)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= tree_win then
      local bufnr = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      
      -- Skip special buffers
      if ft ~= "NvimTree" and ft ~= "" then
        local height = vim.api.nvim_win_get_height(win)
        
        -- Add vertical line on the left side of the window
        vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        
        for line = 0, height - 1 do
          pcall(function()
            vim.api.nvim_buf_set_extmark(bufnr, ns_id, line, 0, {
              virt_text = {{M.config.vertical_char, M.config.vertical_highlight}},
              virt_text_pos = "inline",
              hl_mode = "combine",
            })
          end)
        end
      end
    end
  end
end

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Create autocommands to redraw separators
  local group = vim.api.nvim_create_augroup("SeparatorLines", { clear = true })
  
  -- Redraw horizontal separator on various events
  vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "VimResized"}, {
    group = group,
    callback = draw_horizontal_separator,
  })
  
  -- Redraw vertical separator when nvim-tree is opened/resized
  vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "VimResized"}, {
    group = group,
    callback = draw_vertical_separator,
  })
  
  -- Initial draw
  vim.schedule(function()
    draw_horizontal_separator()
    draw_vertical_separator()
  end)
end

return M
