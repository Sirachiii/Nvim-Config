
local keymap = vim.keymap

-- Toggle relative line numbers
keymap.set('n', '<leader>rn', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'Toggle relative line numbers' })

-- Toggle cursorline
keymap.set('n', '<leader>cl', function()
  if vim.wo.cursorlineopt == "number" then
    vim.wo.cursorlineopt = "line"
  else
    vim.wo.cursorlineopt = "number"
  end
end, { desc = 'Toggle cursorline' })

-- Toggle Neovide Cursor Animations
keymap.set('n', '<leader>ta', function()
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

  keymap.set("n", "<C-=>", function() change_scale(0.1) end, { desc = "Zoom in" })
  keymap.set("n", "<C-->", function() change_scale(-0.1) end, { desc = "Zoom out" })
  keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 0.8 end, { desc = "Reset zoom" }) end

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
    -- pick next buffer that's not nvim-tree
    local next_buf = bufs[1] ~= current and bufs[1] or bufs[2]
    vim.cmd("buffer " .. next_buf)
  end

  -- delete current buffer
  vim.cmd("bdelete! " .. current)
end
keymap.set("n", "<leader>bd", delete_buffer, { desc = "Delete buffer safely" })

-- Add multiple lines around cursor
keymap.set('n', '<leader>P', function()
  vim.cmd('normal! O')
  vim.cmd('normal! o')
  vim.cmd('normal! j')
  vim.cmd('normal! k')
end, { desc = 'Add lines above' })

-- Add lines at top and bottom of file (for my OCD lmao)
keymap.set('n', '<leader>M', function()
  vim.cmd('normal! G')
  vim.cmd('normal! o')
  vim.cmd('normal! gg')
  vim.cmd('normal! O')
end, { desc = 'Add lines around file' })

-- Add lines around selection
keymap.set('n', '<leader>N', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! }O')
  vim.cmd('normal! {o')
  vim.api.nvim_win_set_cursor(0, {pos[1] + 1, pos[2]})
end, { desc = 'Add lines around paragraph' })

-- ==============================
-- Neovim Session Manager
-- ==============================

-- INFO (blue)
vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#7aa2f7"})
vim.api.nvim_set_hl(0, "NotifyINFOTitle",  { fg = "#7aa2f7", bold = true })
vim.api.nvim_set_hl(0, "NotifyINFOIcon",   { fg = "#7aa2f7" })

local session_dir = vim.fn.stdpath('data') .. "/sessions/"

-- Create folder if it doesn't exist
if vim.fn.isdirectory(session_dir) == 0 then
    vim.fn.mkdir(session_dir, "p")
end

local function list_sessions()
    local files = vim.fn.globpath(session_dir, "*.vim", false, true)
    local sessions = {}
    for i, file in ipairs(files) do
        sessions[i] = vim.fn.fnamemodify(file, ":t")
    end
    return sessions, files
end

-- Icons for actions
local icons = {
    save = "💾",
    load = "📂",
    delete = "❌",
    warn = "⚠️",
    error = "⛔",
}

-- Helper: notify with nvim-notify
local function session_notify(msg, level, title)
    vim.notify(msg, level or "info", {
        title = title or "Session Manager",
        timeout = 3000,
        icon = "󰪺",
        stages = "slide",
        render = "default",
    })
end

-- SAVE SESSION
vim.keymap.set('n', '<leader>ss', function()
    local name = vim.fn.input("Save session as: ")
    if name == "" then
        session_notify("Session save cancelled", "warn", "Warn")
        return
    end

    local session_file = session_dir .. name .. ".vim"

    local view = require("nvim-tree.view")
    local tree_was_open = false
    if view.is_visible() then
        tree_was_open = true
        view.close()
    end

    vim.cmd("mksession! " .. session_file)
    session_notify("Saved session: " .. name, "info", "Saved Session")

    if tree_was_open then
        vim.cmd("NvimTreeOpen")
    end
end, { desc = "Save session" })

-- LOAD SESSION
vim.keymap.set('n', '<leader>sl', function()
    local sessions, files = list_sessions()
    if #sessions == 0 then
        session_notify("No sessions found in " .. session_dir, "warn", "Warn")
        return
    end

    local msg = "Available sessions:\n"
    for i, s in ipairs(sessions) do
      msg = msg .. i .. ": " .. s
      if i < #sessions then
          msg = msg .. "\n"
      end
    end
    session_notify(msg, "info", "Load")

    local choice = vim.fn.input("Load which session? (number) ")
    local index = tonumber(choice)
    if index and files[index] then

        -- Close ALL buffers including dashboard
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end

        -- Close all floating windows (including dashboard)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then  -- it's a floating window
                vim.api.nvim_win_close(win, true)
            end
        end

        -- Load Session
        vim.cmd("source " .. files[index])
        session_notify("Loaded session: " .. sessions[index], "info", "Load")
    else
        session_notify("Invalid choice", "error", "Error")
    end
end, { desc = "Load session from list" })

-- DELETE SESSION
vim.keymap.set('n', '<leader>sd', function()
    local sessions, files = list_sessions()
    if #sessions == 0 then
        session_notify("No sessions found in " .. session_dir, "warn", "Warn")
        return
    end

    local msg = "Available sessions:\n"
    for i, s in ipairs(sessions) do
      msg = msg .. i .. ": " .. s
      if i < #sessions then
          msg = msg .. "\n"
      end
    end
    session_notify(msg, "info", "Load")

    local choice = vim.fn.input("Delete which session? (number) ")
    local index = tonumber(choice)
    if index and files[index] then
        os.remove(files[index])
        session_notify("Deleted session: " .. sessions[index], "info", "Delete")
    else
        session_notify("Invalid choice", "error", "Error")
    end
end, { desc = "Delete session" })

-- Close all buffers and go to dashboard safely
local function close_all_buffers_to_dashboard()
    local unsaved = {}

    -- Step 1: Collect all unsaved buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "modified") then
            table.insert(unsaved, buf)
        end
    end

    -- Step 2: Ask user to save unsaved buffers
    if #unsaved > 0 then
        local answer = vim.fn.input("You have unsaved buffers. Save all? (y/n) ")
        if answer:lower() == "y" then
            for _, buf in ipairs(unsaved) do
                vim.api.nvim_buf_call(buf, function()
                    vim.cmd("write")
                end)
            end
        end
    end

    -- Step 3: Delete all normal buffers (skip the dashboard for now)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            -- Skip the dashboard buffer if it's already open
            if not name:match("Snacks") then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
  
    -- Step 5: Open the Snacks dashboard
    vim.cmd("lua Snacks.dashboard()")
end

-- Close all buffers and go to dashboard
vim.keymap.set("n", "<leader>ba", close_all_buffers_to_dashboard, { desc = "Close all buffers" })

