-- ==========================================
-- Colorscheme: Dracula
-- ==========================================

return {
  -- Add Dracula theme
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Customization options
      transparent_bg = true,
      italic_comment = true,
    },
  },

  -- Configure LazyVim to use Dracula
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
