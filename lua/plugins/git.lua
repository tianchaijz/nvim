return {
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  "sindrets/diffview.nvim",

  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      yadm = { enable = false },
      on_attach = require("keymaps").plugin_gitsigns,
    },
  },

  {
    "NeogitOrg/neogit",
    lazy = false,
    config = true,
    keys = require("keymaps").plugin_neogit(),
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = false,
  },
}
