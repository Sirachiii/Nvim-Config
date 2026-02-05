
return {
  "lewis6991/hover.nvim",
  config = function()
    require("hover").setup({
      init = function()
        require("hover.providers.lsp")
      end,
      preview_opts = {
        border = "single"
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP"
      },
    })
    vim.keymap.set("n", "<leader>K", function() 
      require("hover").open()
    end, {desc = "hover.nvim"})

    vim.keymap.set('n', '<C-p>', function()
        require('hover').switch('previous')
    end, { desc = 'hover.nvim (previous source)' })

    vim.keymap.set('n', '<C-n>', function()
        require('hover').switch('next')
    end, { desc = 'hover.nvim (next source)' })
  end
}
