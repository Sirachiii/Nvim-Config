
--- //////////////////////////////////////////////////// ---
--- Vim Options 

if vim.fn.argc() == 0 then
    vim.cmd("cd /users/Sidd/code")
end

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
vim.o.breakindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = false
vim.o.scrolloff = 8
vim.o.list = true
vim.opt.fillchars = { eob = " " }
vim.g.have_nerd_font = true

-- Backups
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Sets vim to ask for confirmation 
vim.o.confirm = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

--- //////////////////////////////////////////////////// ---
--- Neovide Options 

vim.o.guifont = "SF Mono,JetBrainsMonoNL NF:h11"

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

vim.g.neovide_scale_factor = 0.8

vim.g.neovide_opacity = 1
vim.g.neovide_normal_opacity = 1

--- //////////////////////////////////////////////////// ---
