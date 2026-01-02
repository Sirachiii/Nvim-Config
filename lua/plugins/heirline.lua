
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

    local Slant1 = {
      provider = "",
      hl = function()
          return { fg = get_mode_color(), bg = "line" }
      end,
    }

    local FileName = {
      provider = function()
          local filename = vim.fn.expand("%:t")
          if filename == "" then
              return " [No Name] "
          end
          return " " .. filename .. " "
      end,
      hl = { fg = "comment", bg = "line" },
    }

    local Slant2 = {
      provider = "",
      hl = { fg = "line", bg = "bg" },
    }

    -- Git Component
    local Git = {
      condition = conditions.is_git_repo,
      
      {
          provider = function()
              local git_branch = vim.b.gitsigns_head
              return git_branch and ("  " .. git_branch .. " ") or ""
          end,
          hl = { fg = "string", bold = true },
      },
    }

    local GitChanges = {
      condition = conditions.is_git_repo,
      
      provider = function()
          local status = vim.b.gitsigns_status_dict
          if not status then return "" end
          
          local parts = {}
          if status.added and status.added > 0 then
              table.insert(parts, "+" .. status.added)
          end
          if status.changed and status.changed > 0 then
              table.insert(parts, "~" .. status.changed)
          end
          if status.removed and status.removed > 0 then
              table.insert(parts, "-" .. status.removed)
          end
          
          if #parts > 0 then
              return " " .. table.concat(parts, " ") .. " "
          end
          return ""
      end,
      hl = function()
          local status = vim.b.gitsigns_status_dict
          if not status then return {} end
          
          if status.added and status.added > 0 then
              return { fg = "plus" }
          elseif status.changed and status.changed > 0 then
              return { fg = "delta" }
          elseif status.removed and status.removed > 0 then
              return { fg = "error" }
          end
          return {}
      end,
    }

    local Slant3 = {
      condition = conditions.is_git_repo,
      provider = "",
    }

    -- Align (push everything after to the right)
    local Align = { provider = "%=" }

    -- Diagnostics
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      
      {
          provider = "/",
          hl = { fg = "line" },
      },
      {
          provider = function()
              local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
              local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
              local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
              local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
              
              local parts = {}
              if errors > 0 then
                  table.insert(parts, " " .. errors)
              end
              if warnings > 0 then
                  table.insert(parts, " " .. warnings)
              end
              if info > 0 then
                  table.insert(parts, " " .. info)
              end
              if hints > 0 then
                  table.insert(parts, " " .. hints)
              end
              
              return table.concat(parts, " ") .. " "
          end,
          hl = { bg = "line" },
      },
      {
          provider = "",
          hl = { fg = "line" },
      },
      
      update = { "DiagnosticChanged", "BufEnter" },
    }

    -- Working Directory
    local WorkDir = {
      provider = function()
          local cwd = vim.fn.getcwd()
          cwd = vim.fn.fnamemodify(cwd, ":t")
          return "  " .. cwd .. " "
      end,
      hl = { fg = "fg", bold = true },
    }

    local Slant4 = {
      provider = "",
      hl = { fg = "line" },
    }

    -- Ruler (line:column)
    local Ruler = {
      provider = function()
          return " %l:%c "
      end,
      hl = { fg = "comment", bg = "line" },
    }

    local Slant5 = {
      provider = "",
      hl = { fg = "line", bg = "hint" },
    }

    -- Percentage through file
    local ScrollBar = {
      provider = function()
          return " %P "
      end,
      hl = { fg = "bg", bg = "hint", bold = true },
    }

    -- Assemble the statusline
    local StatusLine = {
      ViMode,
      Slant1,
      FileName,
      Slant2,
      Git,
      GitChanges,
      Slant3,
      Align,
      Diagnostics,
      WorkDir,
      Slant4,
      Ruler,
      Slant5,
      ScrollBar,
    }

    -- Setup
    require("heirline").setup({
      statusline = StatusLine,
      opts = {
          colors = colors,
      },
    })
  end,
}


