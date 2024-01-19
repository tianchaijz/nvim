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

function M.notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.schedule(function() vim.notify(msg, level) end)
end

function M.get_paragraph_text()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local start_row, end_row = cursor_row, cursor_row

  while start_row > 0 do
    local line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, true)[1]
    if line == "" then break end
    start_row = start_row - 1
  end

  local num_rows = vim.api.nvim_buf_line_count(0)
  while end_row < num_rows do
    local line = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1]
    if line == "" then break end
    end_row = end_row + 1
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, true)

  return table.concat(lines, "\n") .. "\n"
end

-- https://github.com/neovim/neovim/blob/ba9f86a9cee58dc32ab875da1fd7eac9bc9e88d7/runtime/lua/vim/lsp/buf.lua#L129
-- https://github.com/Mr-LLLLL/interestingwords.nvim/blob/master/lua/interestingwords/init.lua
function M.range_from_selection(mode)
  mode = mode or vim.api.nvim_get_mode().mode
  assert(mode == "v" or mode == "V")

  -- [bufnum, lnum, col, off]; both row and column 1-indexed
  local start = assert(vim.fn.getpos("v"))
  local end_ = assert(vim.fn.getpos("."))
  local start_row = start[2]
  local start_col = start[3]
  local end_row = end_[2]
  local end_col = end_[3]

  -- A user can start visual selection at the end and move backwards
  -- Normalize the range to start < end
  if start_row == end_row and end_col < start_col then
    end_col, start_col = start_col, end_col
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local end_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]

  if mode == "V" then
    start_col = 1
    end_col = #end_line
  end

  local eol = end_col == #end_line

  start_row = start_row - 1
  start_col = start_col - 1
  end_row = end_row - 1

  return { start_row, start_col, end_row, end_col, eol }
end

function M.get_selection()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then return M.get_paragraph_text() end

  local range = M.range_from_selection(mode)
  local lines = vim.api.nvim_buf_get_text(0, range[1], range[2], range[3], range[4], {})

  local text = table.concat(lines, "\n")
  if range[5] then text = text .. "\n" end

  return text
end

return M
