-- ==========================================
-- Custom Keymaps
-- ==========================================
-- Matches Omarchy LazyVim keymaps + NVChad habits

return {
  -- Custom keymaps via LazyVim opts
  {
    "LazyVim/LazyVim",
    opts = function()
      local map = vim.keymap.set

      -- ==========================================
      -- Leader (set in init.lua, but repeated for clarity)
      -- ==========================================
      vim.g.mapleader = "\\"
      vim.g.maplocalleader = "\\"

      -- ==========================================
      -- General
      -- ==========================================
      -- jk to escape
      map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

      -- Find Files (Root Dir)
      map("n", "<leader>ff", LazyVim.pick("files"), { desc = "Find Files (Root)" })

      -- Find Buffers
      map("n", "<leader>fb", LazyVim.pick("buffers"), { desc = "Buffers" })

      -- Find Word (Live Grep)
      map("n", "<leader>fw", LazyVim.pick("live_grep"), { desc = "Find Word (Grep)" })

      -- ==========================================
      -- Additional keymaps from NVChad habits
      -- ==========================================
      -- ; to enter command mode
      map("n", ";", ":", { desc = "Enter command mode", nowait = true })

      -- Faster scrolling
      map("n", "<C-e>", "3<C-e>", { desc = "Scroll down quickly" })
      map("n", "<C-y>", "3<C-y>", { desc = "Scroll up quickly" })

      -- Clear search highlights
      map("n", "<leader><leader>l", ":noh<CR><C-L>", { desc = "Clear search highlights" })

      -- Close all buffers
      map("n", "<leader>m", ":bufdo! bw<CR>", { desc = "Close all buffers" })

      -- Better indent in visual mode
      map("v", ">", ">gv", { desc = "Indent and reselect" })
      map("v", "<", "<gv", { desc = "Outdent and reselect" })

      -- ==========================================
      -- Formatting (LazyVim uses conform by default)
      -- ==========================================
      map("n", "<leader>fm", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
