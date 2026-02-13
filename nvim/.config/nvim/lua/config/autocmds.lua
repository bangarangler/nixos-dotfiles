-- Autocmds are automatically loaded on the VeryLazy event
-- Add any additional autocmds here

-- Disable treesitter indent for svelte (performance issue on NixOS)
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/7585
-- Must run after LazyVim sets indentexpr, so use BufEnter
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.svelte",
  callback = function()
    vim.bo.indentexpr = ""
  end,
})
