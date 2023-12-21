-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

local M = {}

function M.is_win() return vim.loop.os_uname().sysname:find("Windows") ~= nil end

---@param plugin string
function M.has_plugin(plugin) return require("lazy.core.config").spec.plugins[plugin] ~= nil end

---@param name string
function M.plugin_opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then return {} end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function() fn() end,
  })
end

function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler.keys")
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m) return not (keys.have and keys:have(lhs, m)) end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then opts.remap = nil end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

function M.find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then return cwd end

  return git_root
end

function M.call_when(func, cond, ...)
  -- if the condition is true, evaluate the function with the rest of the parameters and return the result
  if cond and type(func) == "function" then return func(...) end
end

return M
