
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
opt.cursorline = true
vim.o.scrolloff = 8
vim.o.list = true
vim.opt.fillchars = { eob = " " }
vim.g.have_nerd_font = true
vim.o.showmode = false
vim.opt.cursorlineopt = "number"
vim.opt.laststatus = 3
vim.o.winborder = "rounded"
vim.o.wrap = false

-- Backups
opt.swapfile = false
opt.backup = false
opt.undofile = true
vim.opt.shada = { "'60", "<50", "s10", "h" }

-- Ultilites
opt.splitright = true
opt.splitbelow = true
vim.o.confirm = true
vim.o.mouse = 'a'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Extras
vim.o.inccommand = 'split'

--- //////////////////////////////////////////////////// ---
--- Neovide Options 

vim.o.guifont = "SF Mono,JetBrainsMonoNL NF:h11"

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

vim.g.neovide_scale_factor = 0.8
vim.g.neovide_cursor_animation_length = 0

--- //////////////////////////////////////////////////// ---

