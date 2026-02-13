-- noxtheme: Ariake Dark - LazyVim colorscheme
-- Note: Ariake Dark isn't a standard nvim theme, so we use a similar Japanese-inspired theme
-- or configure highlights manually

-- Option 1: Use a similar theme (tokyonight-night is closest)
-- vim.cmd.colorscheme("tokyonight-night")

-- Option 2: Manual highlight configuration for pure Ariake colors
local colors = {
  bg = "#1F212A",
  fg = "#B9BED5",
  selection = "#313343",
  comment = "#555C77",
  keyword = "#7E7EDD",
  string = "#9AEFEA",
  constant = "#DDA2F6",
  variable = "#85B1E0",
  func = "#93DDFB",
  type = "#A571F4",
  error = "#E05252",
  white = "#F5FAFF",
  sidebar = "#1C1F26",
}

-- Set background
vim.opt.background = "dark"

-- Apply base highlights
vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.sidebar })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.comment, bg = colors.sidebar })
vim.api.nvim_set_hl(0, "Visual", { bg = colors.selection })
vim.api.nvim_set_hl(0, "Comment", { fg = colors.comment, italic = true })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "String", { fg = colors.string })
vim.api.nvim_set_hl(0, "Number", { fg = colors.constant })
vim.api.nvim_set_hl(0, "Boolean", { fg = colors.constant })
vim.api.nvim_set_hl(0, "Constant", { fg = colors.constant })
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.variable })
vim.api.nvim_set_hl(0, "Function", { fg = colors.func })
vim.api.nvim_set_hl(0, "Type", { fg = colors.type })
vim.api.nvim_set_hl(0, "Error", { fg = colors.error })
vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.error })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.constant })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#222530" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.white })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.comment })
vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.bg })
vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = colors.sidebar })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.white, bg = colors.selection })

-- Treesitter highlights
vim.api.nvim_set_hl(0, "@variable", { fg = colors.variable })
vim.api.nvim_set_hl(0, "@function", { fg = colors.func })
vim.api.nvim_set_hl(0, "@keyword", { fg = colors.keyword })
vim.api.nvim_set_hl(0, "@string", { fg = colors.string })
vim.api.nvim_set_hl(0, "@type", { fg = colors.type })
vim.api.nvim_set_hl(0, "@constant", { fg = colors.constant })
vim.api.nvim_set_hl(0, "@comment", { fg = colors.comment, italic = true })
