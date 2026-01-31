
local keymap = vim.keymap

-- Better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Better Quit 
vim.keymap.set('n', '<leader>q', ':qa<CR>', { desc = 'Quit all' })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Moving Lines
keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap.set("n", "<leader>j", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<leader>k", ":m .-2<CR>==", { desc = "Move line up" })

-- Change to current file's directory
keymap.set('n', '<leader>cd', ':cd %:p:h<CR>', { desc = 'Change to current file directory' })

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybinds to make split navigation easier.
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle relative line numbers
vim.keymap.set('n', '<leader>rn', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'Toggle relative line numbers' })

-- Toggle cursorline
vim.keymap.set('n', '<leader>cl', function()
  if vim.wo.cursorlineopt == "number" then
    vim.wo.cursorlineopt = "line"
  else
    vim.wo.cursorlineopt = "number"
  end
end, { desc = 'Toggle cursorline' })

-- Make so ; is the same as :
vim.keymap.set("n", ";", ":", { desc = "Enter command mode" })

-- Toggle Neovide Cursor Animations
vim.keymap.set('n', '<leader>ta', function()
  if vim.g.neovide_cursor_animation_length == 0 then
    vim.g.neovide_cursor_animation_length = 0.15
    vim.g.neovide_cursor_trail_size = 0.8
    print("Cursor animation: ON")
  else
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0
    print("Cursor animation: OFF")
  end
end, { desc = 'Toggle Neovide cursor animation' })

-- Change neovide scale
if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.8

  local function change_scale(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
  end

  vim.keymap.set("n", "<C-=>", function() change_scale(0.1) end, { desc = "Zoom in (Neovide)" })
  vim.keymap.set("n", "<C-->", function() change_scale(-0.1) end, { desc = "Zoom out (Neovide)" })
  vim.keymap.set("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 0.8
  end, { desc = "Reset zoom (Neovide)" })
end

-- Tabline
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { silent = true })
vim.keymap.set("n", "<leader>bx", "<cmd>BufferLineClose<CR>", { silent = true })

-- Delete Buffer
local function delete_buffer()
  local api = vim.api
  local current = api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_loaded(buf) and api.nvim_buf_get_option(buf, "buftype") ~= "nofile"
  end, vim.api.nvim_list_bufs())

  if #bufs <= 1 then
    -- only one buffer left, just clear it
    vim.cmd("enew")
  else
    -- pick next buffer that's not neo-tree
    local next_buf = bufs[1] ~= current and bufs[1] or bufs[2]
    vim.cmd("buffer " .. next_buf)
  end

  -- safely delete current buffer
  vim.cmd("bdelete! " .. current)
end
vim.keymap.set("n", "<leader>bd", delete_buffer, { desc = "Delete buffer safely" })

-- Nvim Tree Binds
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Remap Ctrl + arrow keys for resizing windows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease Window Width" })

-- Optional: Map <leader>se to equalize all splits
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal sizes" })

-- Add blank lines without leaving normal mode
vim.keymap.set('n', '<leader>o', 'o<Esc>', { desc = 'Add blank line below' })
vim.keymap.set('n', '<leader>O', 'O<Esc>', { desc = 'Add blank line above' })

-- Add multiple lines around cursor
vim.keymap.set('n', '<leader>P', 'o<Esc> O<Esc>', { desc = 'Add lines above' })

-- Open Nav Buddy
vim.keymap.set("n", "<leader>nb", function()
  require("nvim-navbuddy").open()
end, { desc = "Navbuddy" })

-- Comments 
vim.keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<CR>", {
  desc = "Open TODOs in quickfix"
})
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<CR>", {
  desc = "Search TODOs (Telescope)"
})

-- Open File Explorer 
vim.keymap.set('n', '<leader>E', '<cmd>ex .<CR>', { desc = 'Open File Explorer' })

