return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    opts = {
      path_display = { "smart" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Enable telescope fzf native, if installed
      pcall(require("telescope").load_extension, "fzf")

      require("keymaps").plugin_telescope()
    end,
  },
}
