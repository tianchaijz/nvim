local M = {}

M.use_lazy_file = true
M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

--[[
https://github.com/LazyVim/LazyVim/discussions/1583

Defers (and re-triggers) the event to make sure the ui isn't blocked for
initial rendering.

Previously when you opened a file directly like nvim foo.lua,
then Neovim triggers BufReadPost events before VimEnter.
This is annoying, since in our case lsp-config,
treesitter and others would block showing the actual file.

The new change renders the file as fast as possible and right after that loads
any file-based plugins.
As a consequence, the startuptime of nvim foo.lua will now be similar to just doing nvim.
--]]
function M.lazy_file()
  local Event = require("lazy.core.handler.event")

  -- Add support for the LazyFile event
  if M.use_lazy_file then
    -- We'll handle delayed execution of events ourselves
    Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
  else
    -- Don't delay execution of LazyFile events, but let lazy know about the mapping
    Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
    return
  end

  local events = {} ---@type {event: string, buf: number, data?: any}[]
  local done = false

  local function load()
    if #events == 0 or done then return end
    done = true
    vim.api.nvim_del_augroup_by_name("lazy_file")

    ---@type table<string, string[]>
    local skips = {}
    for _, event in ipairs(events) do
      local ev_name = event.event
      if not skips[ev_name] then
        local groups = {} ---@type string[]
        local added = {}
        for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = ev_name })) do
          if autocmd.group_name and not added[autocmd.group_name] then
            table.insert(groups, autocmd.group_name)
            added[autocmd.group_name] = true
          end
        end
        skips[event.event] = groups
      end
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      if vim.api.nvim_buf_is_valid(event.buf) then
        Event.trigger({
          event = event.event,
          exclude = skips[event.event],
          data = event.data,
          buf = event.buf,
        })
        if vim.bo[event.buf].filetype then
          Event.trigger({
            event = "FileType",
            buf = event.buf,
          })
        end
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(M.lazy_file_events, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

function M.setup() M.lazy_file() end

return M
