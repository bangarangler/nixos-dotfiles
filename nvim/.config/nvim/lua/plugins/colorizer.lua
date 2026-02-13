-- ==========================================
-- Colorizer: Show hex colors inline
-- ==========================================

return {
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "html",
        "svelte",
        "javascript",
        "typescript",
        "lua",
      }, {
        -- Default options
        RGB = true,
        RRGGBB = true,
        names = false,    -- Disable named colors like "Blue" (can be slow)
        RRGGBBAA = true,
        rgb_fn = true,    -- CSS rgb() functions
        hsl_fn = true,    -- CSS hsl() functions
        css = true,       -- Enable all CSS features
        css_fn = true,    -- Enable all CSS functions
        mode = "background",
      })
    end,
  },
}
