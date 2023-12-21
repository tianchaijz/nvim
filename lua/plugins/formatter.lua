---@param files string|string[]
local function root_file(files)
  local cache = {}

  return function(self, ctx)
    _ = self
    local dir = cache[ctx.dirname]
    if dir then return dir end

    local found = vim.fs.find(files, { upward = true, path = ctx.dirname })[1]
    if found then
      dir = vim.fs.dirname(found)
      cache[ctx.dirname] = dir
      return dir
    end
  end
end

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local opts = {
        format = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
        },
        formatters_by_ft = {
          go = { "goimports", "gofmt" },
          rust = { "rustfmt" },
          lua = { "stylua" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          cmake = { "clang_format" },
          sh = { "shfmt", "shellcheck" },
          toml = { "taplo" },
          ["*"] = { "codespell" },
          ["_"] = { "trim_whitespace" },
        },
        formatters = {
          stylua = {
            command = "stylua",
            cwd = root_file({ "stylua.toml", ".stylua.toml" }),
            -- cwd = require("conform.util").root_file({ "stylua.toml", ".stylua.toml" }),
            require_cwd = true,
          },
        },
        format_on_save = {
          lsp_fallback = true,
        },
        format_after_save = {
          lsp_fallback = true,
        },
      }

      require("conform").setup(opts)
    end,
  },
}
