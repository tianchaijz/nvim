return {
  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs" },
    config = true,
  },

  { "akinsho/toggleterm.nvim", version = "*", config = true },

  {
    "Mr-LLLLL/interestingwords.nvim",
    lazy = false,
    opts = {
      colors = { "#aeee00", "#ff0000", "#0000ff", "#b88823", "#ffa724", "#ff2c4b" },
      -- colors = { "#8CCBEA", "#A4E57E", "#FFDB72", "#FF7272", "#FFB3FF", "#9999FF" },
      search_count = false,
      navigation = true,
      search_key = "<leader>m",
      cancel_search_key = "<leader>M",
      color_key = "<leader>k",
      cancel_color_key = "<leader>K",
    },
  },

  {
    "ggandor/flit.nvim",
    enabled = true,
    dependencies = { "ggandor/leap.nvim" },
    keys = function()
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = {
      multiline = false,
      labeled_modes = "nx",
      opts = {
        safe_labels = vim.split("dqjklhbnm,ytg;ADQWERJKLHVBNMYTG", ""),
      },
    },
    config = function(_, opts) require("flit").setup(opts) end,
  },

  {
    "smoka7/hop.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
      keys = "asdfqwer;lkjpoiuxcv,mnhytgb",
      case_insensitive = true,
      char2_fallback_key = "<CR>",
      quit_key = "<Esc>",
    },

    config = function(_, opts)
      local hop = require("hop")
      hop.setup(opts)

      local map = vim.keymap.set

      map("n", ",s", ":HopWord<CR>", { silent = true, noremap = false })

      --[[
      local directions = require("hop.hint").HintDirection
      map(
        "",
        "f",
        function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end,
        { remap = true }
      )
      map(
        "",
        "F",
        function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end,
        { remap = true }
      )
      --]]
    end,
  },

  { "folke/todo-comments.nvim" },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- See `:help ibl`
    main = "ibl",
    opts = function()
      local highlight = {
        "CursorColumn",
        "Whitespace",
      }

      return {
        indent = { highlight = highlight, char = "" },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      }
    end,
  },
}
