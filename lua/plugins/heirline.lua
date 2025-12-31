
return {
  "rebelot/heirline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = "UiEnter",
  config = function()
    local heirline = require("heirline")
    local conditions = require("heirline.conditions")

    -- MODE COLORS (link to highlight groups)
    local mode_colors = {
      n = "DiagnosticHint",
      i = "String",
      v = "Type",
      V = "Type",
      c = "Keyword",
      t = "Identifier",
    }

    -- ───────────── RIGHT SIDE ─────────────
    local mode = {
      provider = function() return " "..vim.fn.mode():upper().." " end,
      hl = function() return { link = mode_colors[vim.fn.mode()] or "Normal", bold = true } end,
      left_sep = "",   -- left block
      right_sep = "",  -- right block
    }

    local filename = {
      provider = function() return " "..vim.fn.expand("%:t").." " end,
      cond = conditions.buffer_not_empty,
      hl = { link = "Normal" },
      left_sep = "",
      right_sep = "",
    }

    local git_branch = {
      provider = function()
        local gs = vim.b.gitsigns_status_dict
        return gs and gs.head and (" "..gs.head.." ") or ""
      end,
      cond = conditions.is_git_repo,
      hl = { link = "Identifier" },
      left_sep = "",
      right_sep = "",
    }

    local git_diff = {
      provider = function()
        local gs = vim.b.gitsigns_status_dict
        if not gs then return "" end
        return "+"..(gs.added or 0).." -"..(gs.removed or 0).." "
      end,
      cond = conditions.is_git_repo,
      hl = { link = "DiagnosticInfo" },
      left_sep = "",
      right_sep = "",
    }

    -- ───────────── LEFT SIDE ─────────────
    local folder = {
      provider = function()
        return " "..vim.fn.fnamemodify(vim.fn.getcwd(), ":t").." "
      end,
      hl = { link = "Directory" },
      left_sep = "",
      right_sep = "",
    }

    local pos = {
      provider = function()
        return vim.fn.line(".")..":"..vim.fn.col(".").." "
      end,
      hl = { link = "Comment" },
      left_sep = "",
      right_sep = "",
    }

    local file_pct = {
      provider = function()
        local pct = vim.fn.line(".") / vim.fn.line("$") * 100
        return string.format("%3.0f%%%%", pct)
      end,
      hl = { link = "Comment" },
      left_sep = "",
      right_sep = "",
    }

    -- ───────────── SETUP ─────────────
    heirline.setup({
      statusline = {

        -- RIGHT 
        mode,
        filename,
        git_branch,
        git_diff,

        -- FILL
        { provider = "%=" },

        -- LEFT 
        folder,
        pos,
        file_pct,

      },
    })
  end,
}

