
return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false, -- optional: load when buffer has git
    config = true,
  },
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
    },
    event = "UiEnter",
    lazy = false, -- MUST load immediately
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      -- Colors
      local colors = {
        bg = "#141415",
        fg = "#c3c3d5",
        inactiveBg = "#1c1c24",
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
        plus = "#7fa563",
        delta = "#f3be7c",
      }

      require("heirline").load_colors(colors)

      -- Nerd-font slant
      local slant = ""

      -- Helpers
      local function get_mode_name()
        local mode = vim.fn.mode()
        local names = {
          n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V·LINE", ["\22"] = "V·BLOCK",
          c = "COMMAND", s = "SELECT", R = "REPLACE", t = "TERMINAL"
        }
        return names[mode] or mode
      end

      local function get_mode_color()
        local mode = vim.fn.mode():sub(1,1)
        local map = {
          n="hint", i="func", v="parameter", V="parameter", ["\22"]="parameter",
          c="warning", s="parameter", S="parameter", ["\19"]="parameter",
          R="plus", r="warning", ["!"]="error", t="plus"
        }
        return map[mode] or "func"
      end

      -- Double-slant function
      local function DoubleSlant(prev_color, next_color)
        return {
          provider = slant,
          hl = function()
            return {
              fg = type(prev_color)=="function" and prev_color() or prev_color,
              bg = type(next_color)=="function" and next_color() or next_color
            }
          end
        }
      end

      -- Components
      local ViMode = {
        provider = function() return " " .. get_mode_name() .. " " end,
        hl = function() return { fg="bg", bg=get_mode_color(), bold=true } end,
        update = { "ModeChanged", pattern="*:*", callback=vim.schedule_wrap(function() vim.cmd("redrawstatus") end) }
      }

      local FileName = {
        provider = function()
          local name = vim.fn.expand("%:t")
          return " " .. (name ~= "" and name or "[No Name]") .. " "
        end,
        hl = { fg="comment", bg="line" }
      }

      local Git = {
        condition = conditions.is_git_repo,
        {
          provider = function()
            local branch = vim.b.gitsigns_head
            return branch and ("  " .. branch .. " ") or ""
          end,
          hl = { fg="string", bold=true }
        }
      }

      local GitChanges = {
        condition = conditions.is_git_repo,
        provider = function()
          local s = vim.b.gitsigns_status_dict
          if not s then return "" end
          local parts = {}
          if s.added and s.added>0 then table.insert(parts,"+"..s.added) end
          if s.changed and s.changed>0 then table.insert(parts,"~"..s.changed) end
          if s.removed and s.removed>0 then table.insert(parts,"-"..s.removed) end
          return #parts>0 and (" " .. table.concat(parts," ") .. " ") or ""
        end,
        hl = function()
          local s = vim.b.gitsigns_status_dict
          if not s then return {} end
          if s.added and s.added>0 then return { fg="plus" }
          elseif s.changed and s.changed>0 then return { fg="delta" }
          elseif s.removed and s.removed>0 then return { fg="error" } end
          return {}
        end
      }

      local Diagnostics = {
        condition = function() return #vim.diagnostic.get(0) > 0 end,
        provider = function()
          local d = vim.diagnostic.get(0)
          local e,w,h,i=0,0,0,0
          for _,diag in ipairs(d) do
            if diag.severity==vim.diagnostic.severity.ERROR then e=e+1
            elseif diag.severity==vim.diagnostic.severity.WARN then w=w+1
            elseif diag.severity==vim.diagnostic.severity.HINT then h=h+1
            elseif diag.severity==vim.diagnostic.severity.INFO then i=i+1 end
          end
          local parts={}
          if e>0 then table.insert(parts,e) end
          if w>0 then table.insert(parts,w) end
          if i>0 then table.insert(parts,i) end
          if h>0 then table.insert(parts,h) end
          return " " .. table.concat(parts," ") .. " "
        end,
        hl = { bg="line" },
        update = {"DiagnosticChanged","BufEnter"}
      }

      local WorkDir = {
        provider = function()
          return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
        end,
        hl = { fg="fg", bold=true }
      }

      local Ruler = { provider=" %l:%c ", hl={ fg="comment", bg="line" } }
      local ScrollBar = { provider=" %P ", hl={ fg="bg", bg="hint", bold=true } }
      local Align = { provider="%=" }

      local StatusLine = {
        ViMode,
        DoubleSlant(function() return get_mode_color() end, "line"),
        FileName,
        DoubleSlant("line","bg"),
        Git,
        GitChanges,
        DoubleSlant("line","bg"),
        Align,
        Diagnostics,
        WorkDir,
        DoubleSlant("line","bg"),
        Ruler,
        DoubleSlant("line","hint"),
        ScrollBar,
      }

      require("heirline").setup({ statusline = StatusLine })
    end
  }
}

