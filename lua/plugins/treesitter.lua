-- https://github.com/AstroNvim/AstroNvim/blob/main/lua/plugins/treesitter.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua

return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    opts = {
      indent = { enable = true },
      autotag = { enable = true },
      incremental_selection = { enable = true },
      highlight = {
        enable = true,
        disable = function(_, bufnr) return vim.b[bufnr].large_buf end,
      },
      auto_install = true,
      sync_install = false,
      ensure_installed = {
        "c",
        "cpp",
        "go",
        "rust",
        "lua",
        "luadoc",
        "luap",
        "python",
        "bash",
        "html",
        "javascript",
        "typescript",
        "tsx",
        "vim",
        "vimdoc",
        "comment",
        "query",
        "regex",
        "diff",
        "json",
        "markdown",
        "markdown_inline",
        "json",
        "toml",
        "yaml",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">k"] = { query = "@block.outer", desc = "Swap next block" },
            [">f"] = { query = "@function.outer", desc = "Swap next function" },
            [">a"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<k"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<f"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<a"] = { query = "@parameter.inner", desc = "Swap previous argument" },
          },
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(parser)
          if added[parser] then return false end
          added[parser] = true
          return true
        end, opts.ensure_installed)
      end
      vim.defer_fn(function() require("nvim-treesitter.configs").setup(opts) end, 0)
    end,
  },

  --[=[
  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      { "<leader>tc", function() require("treesitter-context").toggle() end, desc = "Toggle treesitter context" },
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.cmd([[hi TreesitterContextBottom gui=underdashed guisp=#585b70]])
    end,
  },
  --]=]

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
}
