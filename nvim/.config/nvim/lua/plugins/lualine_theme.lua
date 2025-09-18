return {
  -- This is the Lualine plugin. LazyVim usually enables it with `LazyVim.extras.ui.lualine`.
  -- We're just providing `opts` here to override the theme.
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "catppuccin", -- Set Lualine to use the catppuccin theme
      },
    },
  },
}
