return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = { "InsertEnter" },
    opts = {
      filetypes = {
        go = true,
        rust = true,
        c = true,
        cpp = true,
        lua = true,
        python = true,
        ["*"] = false,
      },
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts) require("copilot").setup(opts) end,
  },

  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    opts = {},
    config = function(_, opts) require("copilot_cmp").setup(opts) end,
  },

  {
    "jonahgoldwastaken/copilot-status.nvim",
    dependencies = { "copilot.lua" },
    event = "LazyFile",
    opts = {
      debug = true,
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      -- TODO: lispkind
      { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local border_opts = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }

      return {
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        mapping = require("keymaps").plugin_cmp(),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "buffer", group_index = 1, keyword_length = 5 },
          { name = "path", group_index = 1 },
        }),
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")

      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      cmp.setup(opts)
    end,
  },
}
