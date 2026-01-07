
return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = true,
  },
  {
    "rebelot/heirline.nvim",
    lazy = false,
    event = "UiEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
    },
    config = function()
      local conditions = require("heirline.conditions")

      ------------------------------------------------------------------
      -- Helper: get real highlight background
      ------------------------------------------------------------------
      local function hl_bg(name)
        local hl = vim.api.nvim_get_hl(0, { name = name })
        if not hl or not hl.bg then
          return nil
        end
        return string.format("#%06x", hl.bg)
      end

      local STATUS_BG = hl_bg("StatusLine") or "#141415"
      ------------------------------------------------------------------
      -- Colors
      ------------------------------------------------------------------
      local colors = {
        bg = STATUS_BG,
        fg = "#c3c3d5",
        line = "#252530",
        comment = "#606079",

        func = "#c48282",
        string = "#e8b589",
        parameter = "#bb9dbd",

        error = "#d8647e",
        warning = "#f3be7c",
        hint = "#7e98e8",
        info = "#7aa2f7",

        plus = "#7fa563",
        delta = "#f3be7c",
      }

      require("heirline").load_colors(colors)

      ------------------------------------------------------------------
      -- Nerd Font Powerline slants (single slant)
      ------------------------------------------------------------------
      local SLANT_RIGHT = ""
      local SLANT_LEFT  = ""

      local function RightSlant(bg_a, bg_b)
        return {
          provider = SLANT_RIGHT,
          hl = function()
            return {
              fg = type(bg_a) == "function" and bg_a() or bg_a,
              bg = bg_b,
            }
          end,
        }
      end

      local function LeftSlant(bg_a, bg_b)
        return {
          provider = SLANT_LEFT,
          hl = function()
            return {
              fg = bg_b,
              bg = type(bg_a) == "function" and bg_a() or bg_a,
            }
          end,
        }
      end

      ------------------------------------------------------------------
      -- Mode helpers
      ------------------------------------------------------------------
      local function mode_name()
        return ({
          n = "NORMAL",
          i = "INSERT",
          v = "VISUAL",
          V = "V-LINE",
          ["\22"] = "V-BLOCK",
          c = "COMMAND",
          R = "REPLACE",
          t = "TERMINAL",
        })[vim.fn.mode()] or vim.fn.mode()
      end

      local function mode_color()
        return ({
          n = "hint",
          i = "func",
          v = "parameter",
          V = "parameter",
          ["\22"] = "parameter",
          c = "warning",
          R = "plus",
          t = "plus",
        })[vim.fn.mode():sub(1, 1)] or "func"
      end

      ------------------------------------------------------------------
      -- Components
      ------------------------------------------------------------------
      local ViMode = {
        provider = function()
          return " " .. mode_name() .. " "
        end,
        hl = function()
          return { fg = "bg", bg = mode_color(), bold = true }
        end,
        update = {
          "ModeChanged",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      local FileName = {
        provider = function()
          local name = vim.fn.expand("%:t")
          return " " .. (name ~= "" and name or "[No Name]") .. " "
        end,
        hl = { fg = "fg", bg = "line" },
      }

      local GitBranch = {
        condition = conditions.is_git_repo,
        provider = function()
          return "  " .. (vim.b.gitsigns_head or "") .. " "
        end,
        hl = { fg = "string", bold = true },
      }

      ------------------------------------------------------------------
      -- Coloured Git changes
      ------------------------------------------------------------------
      local GitChanges = {
        condition = conditions.is_git_repo,

        {
          condition = function()
            return vim.b.gitsigns_status_dict
              and vim.b.gitsigns_status_dict.added
              and vim.b.gitsigns_status_dict.added > 0
          end,
          provider = function()
            return "  " .. vim.b.gitsigns_status_dict.added
          end,
          hl = { fg = "plus"},
        },

        {
          condition = function()
            return vim.b.gitsigns_status_dict
              and vim.b.gitsigns_status_dict.changed
              and vim.b.gitsigns_status_dict.changed > 0
          end,
          provider = function()
            return "  " .. vim.b.gitsigns_status_dict.changed
          end,
          hl = { fg = "delta" },
        },

        {
          condition = function()
            return vim.b.gitsigns_status_dict
              and vim.b.gitsigns_status_dict.removed
              and vim.b.gitsigns_status_dict.removed > 0
          end,
          provider = function()
            return "  " .. vim.b.gitsigns_status_dict.removed
          end,
          hl = { fg = "error" },
        },

        { provider = " " },
      }

      ------------------------------------------------------------------
      -- Coloured Diagnostics
      ------------------------------------------------------------------
      local Diagnostics = {
        condition = function()
          return #vim.diagnostic.get(0) > 0
        end,

        {
          provider = function()
            local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            return n > 0 and ("  " .. n) or ""
          end,
          hl = { fg = "error" },
        },

        {
          provider = function()
            local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            return n > 0 and ("  " .. n) or ""
          end,
          hl = { fg = "warning" },
        },

        {
          provider = function()
            local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            return n > 0 and ("  " .. n) or ""
          end,
          hl = { fg = "info" },
        },

        {
          provider = function()
            local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            return n > 0 and (" 󰌵 " .. n) or ""
          end,
          hl = { fg = "hint" },
        },

        { provider = " " },
        hl = { bg = "bg" },
        update = { "DiagnosticChanged", "BufEnter" },
      }

      local WorkDir = {
        provider = function()
          return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
        end,
        hl = { fg = "fg", bold = true },
      }

      local Ruler = {
        provider = " %l:%c ",
        hl = { fg = "comment", bg = "line" },
      }

      local ScrollBar = {
        provider = " %P ",
        hl = { fg = "bg", bg = "hint", bold = true },
      }

      local Align = { provider = "%=" }

      local funnyFace = {
        provider = " ._. ",
        hl = { fg = "line", bg = "hint", bold = true },
      }

      ------------------------------------------------------------------
      -- Final Statusline
      ------------------------------------------------------------------
      local StatusLine = {
        ViMode,
        RightSlant(function() return mode_color() end, "line"),
        FileName,
        RightSlant("line", "bg"),
        GitBranch,
        GitChanges,
        RightSlant("bg", "bg"),
        Align,
        RightSlant("bg", "hint"),
        funnyFace,
        LeftSlant("hint", "bg"),
        Align,
        Diagnostics,
        WorkDir,
        LeftSlant("bg", "line"),
        Ruler,
        LeftSlant("line", "hint"),
        ScrollBar,
      }

      require("heirline").setup({
        statusline = StatusLine,
      })
    end,
  },
}
