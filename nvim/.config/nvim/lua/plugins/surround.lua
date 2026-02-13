-- ==========================================
-- nvim-surround - DISABLED
-- ==========================================
-- LazyVim has mini.surround available as an extra. Enable it in init.lua:
--   { import = "lazyvim.plugins.extras.coding.mini-surround" }
--
-- mini.surround keybinds:
--   sa  - Add surrounding (e.g., saiw" adds quotes around word)
--   sd  - Delete surrounding
--   sr  - Replace surrounding
--
-- If you prefer nvim-surround (different keybinds: ys, ds, cs),
-- uncomment below and don't enable the mini-surround extra.
--[[
return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
--]]

return {}
