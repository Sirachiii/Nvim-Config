return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Setup Mason
    require("mason").setup()

    -- Setup Mason-LSPconfig
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",      -- Lua
        "pyright",     -- Python
        "ts_ls",       -- TypeScript/JavaScript
        "clangd",      -- C 
      },
      automatic_installation = true,
    })

    -- Lua
    vim.lsp.config.lua_ls = {
      cmd = { "lua-language-server" },
      root_markers = { ".luarc.json", ".git" },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    }

    -- Python
    vim.lsp.config.pyright = {
      cmd = { "pyright-langserver", "--stdio" },
      root_markers = { "pyproject.toml", "setup.py", ".git" },
    }

    -- TypeScript/JavaScript
    vim.lsp.config.ts_ls = {
      cmd = { "typescript-language-server", "--stdio" },
      root_markers = { "package.json", "tsconfig.json", ".git" },
    }

    -- Enable the servers
    vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "clangd" })

    -- Add keymaps for LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts, { desc = "View all positions" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts, { desc = "View definition" })
        vim.keymap.set("n", "<leader>rm", vim.lsp.buf.rename, opts, { desc = "Rename item" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts, { desc = "Show code action" })
      end,
    })
  end,
}
