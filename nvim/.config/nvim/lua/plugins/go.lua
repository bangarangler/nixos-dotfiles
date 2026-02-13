-- ==========================================
-- Go Development - DISABLED
-- ==========================================
-- LazyVim's Go extra (enabled in init.lua) handles:
--   - gopls LSP
--   - gofumpt formatting
--   - goimports
--   - delve debugging (via dap extra)
--
-- Uncomment if you need gopher.nvim for struct tags or custom Go keymaps.
--[[
return {
  -- Gopher.nvim for Go struct tags, etc.
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
    opts = {},
    keys = {
      { "<leader>gsj", "<cmd>GoTagAdd json<CR>", desc = "Add JSON struct tags", ft = "go" },
      { "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", desc = "Add YAML struct tags", ft = "go" },
      { "<leader>gsr", "<cmd>GoTagRm<CR>", desc = "Remove struct tags", ft = "go" },
      { "<leader>gie", "<cmd>GoIfErr<CR>", desc = "Add if err != nil", ft = "go" },
    },
  },

  -- DAP-Go (debug Go tests)
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    opts = {},
    keys = {
      {
        "<leader>dgt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug Go Test",
        ft = "go",
      },
      {
        "<leader>dgl",
        function()
          require("dap-go").debug_last()
        end,
        desc = "Debug Last Go Test",
        ft = "go",
      },
    },
  },
}
--]]

return {}
