local lsp_servers = {
  gopls = {},
  rust_analyzer = {
    opts = {
      cmd = {
        "rustup",
        "run",
        "stable",
        "rust-analyzer",
      },
    },
  },
  lua_ls = {
    opts = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            maxPreload = 100000,
            preloadFileSize = 10000,
            checkThirdParty = false,
          },
        },
      },
    },
  },
  pyright = {},
  taplo = {}, -- toml
  jsonls = {},
}

return {
  -- Useful status updates for LSP
  { "j-hui/fidget.nvim", config = true },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      auto_sync = true,
      ensure_installed = {
        "stylua",
        "luacheck",
        "shfmt",
        "shellcheck",
        "codespell",
      },
    },
  },

  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim" },
    },

    config = function()
      -- Setup neovim lua configuration
      require("neodev").setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local mason_lspconfig = require("mason-lspconfig")

      local ensure_installed = {}
      for name, srv in pairs(lsp_servers) do
        if srv.enable ~= false then table.insert(ensure_installed, name) end
      end

      mason_lspconfig.setup({ ensure_installed = ensure_installed })

      local function on_attach(client, bufnr)
        if client.name == "copilot" then return end
        require("keymaps").lsp(bufnr)
      end

      mason_lspconfig.setup_handlers({
        function(srv_name)
          local opts = lsp_servers[srv_name].opts or {}
          opts = vim.tbl_deep_extend("keep", opts, { capabilities = capabilities, on_attach = on_attach })
          require("lspconfig")[srv_name].setup(opts)
        end,
      })
    end,
  },

  --[[ -- Improves the Neovim built-in LSP experience
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "c", "cpp", "go", "rust", "lua", "python" },
    config = function() require("lspsaga").setup({}) end,
  },
  --]]

  -- A code outline window for skimming and quick navigation
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = { "treesitter", "lsp", "markdown", "man" },
      layout = {
        min_width = 30,
        max_width = { 50, 0.25 },
        default_direction = "prefer_left",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts) require("aerial").setup(opts) end,
  },
}
