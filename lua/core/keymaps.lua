
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
vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

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

