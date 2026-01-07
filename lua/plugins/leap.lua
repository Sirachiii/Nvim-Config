return {
  "ggandor/leap.nvim",
  config = function()
    local leap = require("leap")
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
  end,
}
