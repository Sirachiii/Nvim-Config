
return {
  "rebelot/heirline.nvim",
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    -- Colors matching your theme
    local colors = {
      bg = "#141415",
      inactiveBg = "#1c1c24",
      fg = "#cdcdcd",
      floatBorder = "#878787",
      line = "#252530",
      comment = "#606079",
      builtin = "#b4d4cf",
      func = "#c48282",
      string = "#e8b589",
      number = "#e0a363",
      property = "#c3c3d5",
      constant = "#aeaed1",
      parameter = "#bb9dbd",
      visual = "#333738",
      error = "#d8647e",
      warning = "#f3be7c",
      hint = "#7e98e8",
      operator = "#90a0b5",
      keyword = "#6e94b2",
      type = "#9bb4bc",
      search = "#405065",
      plus = "#7fa563",
      delta = "#f3be7c",
    }

    -- Helper functions
    local function get_mode_name()
      local mode = vim.fn.mode(1)
      local names = {
          n = "NORMAL",
          no = "N·PENDING",
          nov = "N·PENDING",
          noV = "N·PENDING",
          ["no\22"] = "N·PENDING",
          niI = "N·INSERT",
          niR = "N·REPLACE",
          niV = "N·V-REPLACE",
          nt = "NORMAL",
          v = "VISUAL",
          vs = "VISUAL",
          V = "V·LINE",
          Vs = "V·LINE",
          ["\22"] = "V·BLOCK",
          ["\22s"] = "V·BLOCK",
          s = "SELECT",
          S = "S·LINE",
          ["\19"] = "S·BLOCK",
          i = "INSERT",
          ic = "INSERT",
          ix = "INSERT",
          R = "REPLACE",
          Rc = "REPLACE",
          Rx = "REPLACE",
          Rv = "V·REPLACE",
          Rvc = "V·REPLACE",
          Rvx = "V·REPLACE",
          c = "COMMAND",
          cv = "EX",
          r = "...",
          rm = "MORE",
          ["r?"] = "CONFIRM",
          ["!"] = "SHELL",
          t = "TERMINAL",
      }
      return names[mode] or "UNKNOWN"
    end

    local function get_mode_color()
      local mode = vim.fn.mode():sub(1, 1)
      local colors_map = {
          n = "hint",       -- normal: blue
          i = "func",       -- insert: pink/red
          v = "parameter",  -- visual: purple
          V = "parameter",
          ["\22"] = "parameter",
          c = "warning",    -- command: orange
          s = "parameter",
          S = "parameter",
          ["\19"] = "parameter",
          R = "plus",       -- replace: green
          r = "warning",
          ["!"] = "error",
          t = "plus",       -- terminal: green
      }
      return colors_map[mode] or "func"
    end

    -- Components
    local ViMode = {
      provider = function()
          return " " .. get_mode_name() .. " "
      end,
      hl = function()
          return { fg = "bg", bg = get_mode_color(), bold = true }
      end,
      update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
              vim.cmd("redrawstatus")
          end),
      },
    }


