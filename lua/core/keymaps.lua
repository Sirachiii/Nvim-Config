
local keymap = vim.keymap

-- Better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Better Quit 
keymap.set('n', '<leader>q', ':qa<CR>', { desc = 'Quit all' })

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

-- Make so ; is the same as :
keymap.set("n", ";", ":", { desc = "Enter command mode" })

-- Tabline
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })
keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { silent = true })

-- Nvim Tree Binds
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Remap Ctrl + arrow keys for resizing windows
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase Window Height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease Window Height" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase Window Width" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease Window Width" })

-- Optional: Map <leader>se to equalize all splits
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal sizes" })

-- Add blank lines without leaving normal mode
keymap.set('n', '<leader>o', 'o<Esc>', { desc = 'Add blank line below' })
keymap.set('n', '<leader>O', 'O<Esc>', { desc = 'Add blank line above' })

-- Open Nav Buddy
keymap.set("n", "<leader>nb", function()
  require("nvim-navbuddy").open()
end, { desc = "Navbuddy" })

-- Comments 
keymap.set("n", "<leader>tq", "<cmd>TodoQuickFix<CR>", {
  desc = "Open TODOs in quickfix"
})
keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<CR>", {
  desc = "Search TODOs (Telescope)"
})

-- Open File Explorer 
keymap.set('n', '<leader>E', '<cmd>ex .<CR>', { desc = 'Open File Explorer' })

-- Toggle relative line numbers
-- keymap.set('n', '<leader>rn', function(), { desc = 'Toggle relative line numbers' })

-- Toggle cursorline
-- keymap.set('n', '<leader>cl', function(), { desc = 'Toggle cursorline' })

-- Toggle Neovide Cursor Animations
-- keymap.set('n', '<leader>ta', function(), { desc = 'Toggle Neovide cursor animation' })

-- Change neovide scale
-- keymap.set("n", "<C-=>", function() { desc = "Zoom in (Neovide)" })
-- keymap.set("n", "<C-->", function() { desc = "Zoom out (Neovide)" })
-- keymap.set("n", "<C-0>", function() { desc = "Reset zoom (Neovide)" })

-- Delete Buffer
-- keymap.set("n", "<leader>bd", function() , { desc = "Delete buffer safely" })

-- Add multiple lines around cursor
-- keymap.set('n', '<leader>P', function(), { desc = 'Add lines above' })

-- Add lines at top and bottom of file (for my OCD lmao)
-- keymap.set('n', '<leader>M', function(), { desc = 'Add lines around file' })

-- Add lines around selection
-- keymap.set('n', '<leader>N', function(), { desc = 'Add lines around paragraph' })

-- Close all Buffers and go to Dashboard
-- vim.keymap.set("n", "<leader>ba", function(), { desc = "Close all buffers and open dashboard" })

