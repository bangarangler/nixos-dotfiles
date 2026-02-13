-- Florida-man (GTA VI) for Neovim - Catppuccin Frappe base
-- Uses catppuccin with frappe flavor and custom overrides
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "frappe",
      transparent_background = false,
      term_colors = true,
      color_overrides = {
        frappe = {
          rosewater = "#f2d5cf",
          flamingo = "#eebebe",
          pink = "#f4b8e4",
          mauve = "#ca9ee6",
          red = "#e78284",
          maroon = "#ea999c",
          peach = "#ef9f76",
          yellow = "#e5c890",
          green = "#a6d189",
          teal = "#81c8be",
          sky = "#99d1db",
          sapphire = "#85c1dc",
          blue = "#8caaee",
          lavender = "#babbf1",
          text = "#c6d0f5",
          subtext1 = "#b5bfe2",
          subtext0 = "#a5adce",
          overlay2 = "#949cbb",
          overlay1 = "#838ba7",
          overlay0 = "#737994",
          surface2 = "#626880",
          surface1 = "#51576d",
          surface0 = "#414559",
          base = "#303446",
          mantle = "#292c3c",
          crust = "#232634",
        },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        flash = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
