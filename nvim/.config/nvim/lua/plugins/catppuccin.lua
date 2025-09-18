return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    auto_integrations = true,
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        term_colors = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    --   Thowing and error, and idk what it does so it's getting thrown out
    -- specs = {
    -- {
    --     "akinsho/bufferline.nvim",
    --     optional = true,
    --     opts = function(_, opts)
    --       if (vim.g.colors_name or ""):find("catppuccin") then
    --         opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
    --       end
    --     end,
    --   },
    -- },
  },
}
