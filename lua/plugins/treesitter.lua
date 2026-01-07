
-- lua/plugins/treesitter_windows.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,       -- always use latest
    build = ":TSUpdate",    -- downloads/updates prebuilt parsers
    event = { "BufReadPost", "BufNewFile" }, -- lazy-load on file open
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then return end

      ts.setup({
        -- Only common languages with prebuilt binaries on Windows
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "typescript",
          "json",
          "html",
          "css",
          "bash",
        },

        -- Highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- Indentation
        indent = {
          enable = true,
        },

        -- Incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

        -- Disable compilation of parsers: only use prebuilt DLLs
        parser_install_dir = vim.fn.stdpath("data") .. "/treesitter", -- default location
      })

      -- Force Treesitter to use prebuilt binaries on Windows
      -- NOTE: nvim-treesitter 0.9+ automatically does this if a DLL exists
      vim.cmd([[
        augroup TreesitterPrebuilt
          autocmd!
          autocmd BufReadPost,BufNewFile * TSUpdate
        augroup END
      ]])
    end,
  },
}

