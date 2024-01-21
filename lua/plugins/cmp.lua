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

      -- https://github.com/LunarVim/LunarVim/blob/e85637c2408264f2591b9c9bca073cd58d314a97/lua/lvim/core/cmp.lua#L120
      return {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
          keyword_length = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.menu = ({
              nvim_lsp = "[L]",
              luasnip = "[S]",
              buffer = "[B]",
              path = "[P]",
              copilot = "",
            })[entry.source.name]
            item.abbr = string.sub(item.abbr, 1, 32)
            return item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          buffer = 1,
          path = 1,
        },
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2, max_item_count = 2 },
          {
            name = "nvim_lsp",
            group_index = 1,
            entry_filter = function(entry)
              local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
              if kind == "Field" then
                local text = entry:get_insert_text()
                if text:find("^_nvim_") then return false end
              end
              return true
            end,
          },
          { name = "buffer", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "path", group_index = 1 },
        }),
        mapping = require("keymaps").plugin_cmp(),
        cmdline = {
          enable = false,
          options = {
            {
              type = ":",
              sources = {
                { name = "path" },
                { name = "cmdline" },
              },
            },
            {
              type = { "/", "?" },
              sources = {
                { name = "buffer" },
              },
            },
          },
        },
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

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = { java = false },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = function(_, opts)
      local autopairs_enabled = true
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)
      if not autopairs_enabled then npairs.disable() end
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if cmp_status_ok then
        cmp.event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done({
            tex = false,
          })
        )
      end
    end,
  },
}
