-- ==========================================
-- Hop.nvim (Quick Navigation) - DISABLED
-- ==========================================
-- LazyVim includes flash.nvim by default which provides the same
-- functionality with more features. Use flash.nvim keybinds instead:
--   s     - Flash jump
--   S     - Flash treesitter
--   r     - Remote flash (in operator-pending mode)
--
-- Uncomment below if you prefer hop.nvim over flash.nvim
--[[
return {
  "smoka7/hop.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    keys = "etovxqpdygfblzhckisuran",
  },
  keys = {
    { "<leader><leader>f", "<cmd>HopAnywhere<CR>", desc = "Hop Anywhere" },
    { "<leader><leader>fw", "<cmd>HopWord<CR>", desc = "Hop Word" },
    { "<leader><leader>fc", "<cmd>HopChar2<CR>", desc = "Hop 2 Chars" },
    { "<leader><leader>fl", "<cmd>HopLine<CR>", desc = "Hop Line" },
    { "<leader><leader>fls", "<cmd>HopLineStart<CR>", desc = "Hop Line Start" },
    { "<leader><leader>fp", "<cmd>HopPattern<CR>", desc = "Hop Pattern" },
  },
}
--]]

return {}
