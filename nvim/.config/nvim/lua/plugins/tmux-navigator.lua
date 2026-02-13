-- ==========================================
-- Tmux Navigator
-- ==========================================
-- Seamless navigation between tmux panes and neovim splits

return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate Left (Tmux/Nvim)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate Down (Tmux/Nvim)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate Up (Tmux/Nvim)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate Right (Tmux/Nvim)" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", desc = "Navigate Previous (Tmux/Nvim)" },
  },
}
