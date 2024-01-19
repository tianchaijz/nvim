-- https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/mappings.lua
-- https://github.com/NvChad/NvChad/blob/v2.0/lua/core/mappings.lua
-- https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/whichkey.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua
-- https://github.com/zbirenbaum/zvim-lazy/blob/master/lua/utils/mappings.lua
-- https://github.com/jonahgoldwastaken/dotfiles/blob/main/.config/nvim/lua/plugins/editor.lua

--[[
|        Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
Command        +------+-----+-----+-----+-----+-----+------+------+
[nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
[nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
--]]

local Util = require("util")

local map = vim.keymap.set
local function nmap(lhs, rhs, opts) map("n", lhs, rhs, opts) end
local function vmap(lhs, rhs, opts) map("v", lhs, rhs, opts) end

local M = {}

function M._which_key()
  local sections = {
    ["g"] = { name = "+goto" },
    ["]"] = { name = "+next" },
    ["["] = { name = "+prev" },
    ["<leader>a"] = { name = "+align" },
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>c"] = { name = "+code/cursor/copy" },
    ["<leader>e"] = { name = "+explorer" },
    ["<leader>g"] = { name = "+git" },
    ["<leader>h"] = { name = "+help/hlighlight" },
    ["<leader>l"] = { name = "+lsp" },
    ["<leader>s"] = { name = "+search" },
    ["<leader>t"] = { name = "+toggle" },
    ["<leader>w"] = { name = "+windows" },
    ["<leader>x"] = { name = "+diagnostics/quickfix" },
    ["<leader>S"] = { name = "+session" },
    ["<leader><tab>"] = { name = "+tabs" },
  }
  for _, sec in pairs(sections) do
    sec._ = "which_key_ignore"
  end

  require("which-key").register(sections, { mode = { "n", "v" } })
end

function M._common()
  -- Keymaps for better default experience
  map({ "n", "v" }, "<leader>", "<Nop>")

  -- Save key strokes (now we do not need to press shift to enter command mode).
  map({ "n", "x" }, ";", ":")
  map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

  nmap("<leader><cr>", "<cmd>noh<cr>", { desc = "Disable search highlight" })

  -- :help g
  map("x", "$", "g_")

  -- Better up/down
  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

  -- Navigate windows
  nmap("<C-h>", "<C-w>h", { desc = "Goto left window" })
  nmap("<C-j>", "<C-w>j", { desc = "Goto lower window" })
  nmap("<C-k>", "<C-w>k", { desc = "Goto upper window" })
  nmap("<C-l>", "<C-w>l", { desc = "Goto right window" })

  -- Kill line
  map("i", "<C-k>", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if line ~= "" then
      line = line:sub(0, col)
      vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line })
    end
  end, { desc = "Kill line" })
  map("c", "<C-k>", "<C-f>d$<C-c><End>")

  -- Resize window
  nmap("<A-h>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
  nmap("<A-H>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
  nmap("<A-w>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
  nmap("<A-W>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })

  -- Split window
  nmap("<leader>-", "<C-w>s", { desc = "Split window below" })
  nmap("<leader>|", "<C-w>v", { desc = "Split window right" })
  nmap("<leader>w-", "<C-w>s", { desc = "Split window below" })
  nmap("<leader>w|", "<C-w>v", { desc = "Split window right" })
  nmap("<leader>ww", "<C-w>p", { desc = "Goto other window" })
  nmap("<leader>wd", "<C-w>c", { desc = "Delete window" })

  -- Buffers
  nmap("<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  nmap("<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  nmap("[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  nmap("]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
  nmap("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

  -- Navigate tabs
  nmap("]t", vim.cmd.tabnext, { desc = "Next tab" })
  nmap("[t", vim.cmd.tabprevious, { desc = "Previous tab" })

  map("x", "ss", [[y:%s/<C-r>"/g<left><left>/]], { desc = "Visual substitute" })

  -- It solves the issue, where you want to delete empty line, but dd will override your last yank.
  -- [src: https://www.reddit.com/r/neovim/comments/w0jzzv/comment/igfjx5y/]
  local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
      return '"_dd'
    else
      return "dd"
    end
  end
  map("n", "dd", smart_dd, { expr = true, desc = "Smart deletion" })

  -- With this you can use > < multiple time for changing indent when you visual selected text.
  map("v", "<", "<gv", { desc = "Shift lines" })
  map("v", ">", ">gv", { desc = "Shift lines" })

  -- https://github.com/sei40kr/nvimacs/blob/main/plugin/nvimacs.lua
  map("!", "<C-a>", "<Home>", { desc = "Begin" })
  map("!", "<C-b>", "<Left>", { desc = "Left" })
  map("!", "<C-f>", "<Right>", { desc = "Right" })
  map("i", "<C-e>", "<End>", { desc = "End" })
  map("i", "<C-p>", "<Up>", { desc = "Up" })
  map("i", "<C-n>", "<Down>", { desc = "Down" })

  local function set_cc()
    local win = vim.api.nvim_get_current_win()
    local pos = vim.api.nvim_win_get_cursor(0)

    local col = tostring(pos[2] + 1)
    local cc = vim.api.nvim_get_option_value("colorcolumn", { win = win })
    local arr = cc == "" and {} or vim.split(cc, ",")

    if vim.tbl_contains(arr, col) then
      arr = vim.tbl_filter(function(v) return v ~= col end, arr)
    else
      table.insert(arr, col)
    end

    vim.api.nvim_win_set_option(win, "colorcolumn", table.concat(arr, ","))
  end

  -- vim.cmd([[highlight ColorColumn guibg=Green]])
  nmap("<leader>hc", set_cc, { desc = "Hlighlight current column" })
  nmap("<leader>cl", function() vim.opt.cursorcolumn = not vim.opt.cursorcolumn end, { desc = "Togle cursor column" })
end

function M._paste()
  local paste_file = "/tmp/vim_paste"

  local function tee()
    local text = Util.get_selection()
    local fd = assert(io.open(paste_file, "w+"))
    fd:write(text)
    fd:close()

    Util.notify("Copied to " .. paste_file)
  end

  local function cat()
    local fd = io.open(paste_file, "r")
    if not fd then return end
    local data = fd:read("*a")
    fd:close()

    local pos = assert(vim.fn.getpos("."))
    local row, col = pos[2], pos[3]
    row = row - 1

    if data:find("\n") then
      vim.api.nvim_buf_set_lines(0, row, row, false, vim.split(data, "\n"))
    else
      local line = vim.fn.getline(".")
      if col > #line then col = col - 1 end
      vim.api.nvim_buf_set_text(0, row, col, row, col, { data })
    end
  end

  map({ "n", "v" }, ",tee", tee, { desc = "Tee" })
  nmap(",cat", cat, { desc = "Cat" })
end

-- https://github.com/jpalardy/vim-slime/blob/db486eaa39f14d130ddf6338aaa02127aa04b272/autoload/slime.vim#L76
function M._tmux()
  local paste_file = "/tmp/vim_tmux_paste"
  local pane

  local function send()
    local text = Util.get_selection()

    local fd = assert(io.open(paste_file, "w+"))
    fd:write(text)
    fd:close()

    if not pane then
      local window = vim.fn.systemlist("tmux display-message -p '#I'")[1]
      pane = window .. ".0"
    end

    local load_cmd = "tmux load-buffer " .. paste_file
    vim.fn.system(load_cmd)

    local send_cmd = "tmux paste-buffer -d -t " .. pane
    vim.fn.system(send_cmd)
    -- vim.fn.system("tmux send-keys -t " .. pane .. " Enter")
  end

  map({ "n", "v" }, "<C-c><C-c>", send, { desc = "Send selected text to tmux pane" })
end

-- Copy to system clipboard
function M.plugin_osc52()
  local pkg = require("osc52")
  vmap("<leader>cy", pkg.copy_visual, { desc = "Copy to system clipboard" })
  nmap("<leader>cy", pkg.copy_operator, { desc = "Copy to system clipboard" })
  nmap("<leader>cr", function() pkg.copy_register('"') end, { desc = "Copy default register to system clipboard" })
end

function M._comment()
  local pkg = require("Comment.api")
  -- XXX: gcc
  nmap("<leader>/", function() pkg.toggle.linewise.current() end, { desc = "Toggle comment line" })
  -- XXX: gbc
  vmap("<leader>/", function() pkg.toggle.linewise(vim.fn.visualmode()) end, { desc = "Toggle comment for selection" })
end

function M._git()
  nmap("<leader>ga", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Git add file" })
  nmap("<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
end

M.plugin_neogit = function() return { { "<leader>gn", "<cmd>Neogit<cr>" } } end

M.plugin_gitsigns = function(bufnr)
  local function buf_nmap(lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    map("n", lhs, rhs, opts)
  end

  local gs = require("gitsigns")

  buf_nmap("]c", function()
    if vim.wo.diff then return "]c" end
    vim.schedule(function() gs.next_hunk() end)
    return "<Ignore>"
  end, { expr = true, desc = "Jump to next git hunk" })

  buf_nmap("[c", function()
    if vim.wo.diff then return "[c" end
    vim.schedule(function() gs.prev_hunk() end)
    return "<Ignore>"
  end, { expr = true, desc = "Jump to previous git hunk" })

  buf_nmap("<leader>gb", function() gs.blame_line() end, { desc = "View git blame" })
  buf_nmap("<leader>gB", function() gs.blame_line({ full = true }) end, { desc = "View full git blame" })

  buf_nmap("<leader>gp", gs.preview_hunk, { desc = "Preview git hunk" })
  buf_nmap("<leader>gr", gs.reset_hunk, { desc = "Reset git hunk" })
  buf_nmap("<leader>gR", gs.reset_buffer, { desc = "Reset git buffer" })
  buf_nmap("<leader>gs", gs.stage_hunk, { desc = "Stage git hunk" })
  buf_nmap("<leader>gS", gs.stage_buffer, { desc = "Stage git buffer" })
  buf_nmap("<leader>gu", gs.undo_stage_hunk, { desc = "Unstage git hunk" })
  buf_nmap("<leader>gd", gs.diffthis, { desc = "View git diff" })
  buf_nmap("<leader>gD", function() gs.diffthis("~") end, { desc = "Git diff against last commit" })
end

function M.lsp(bufnr)
  local lsp = vim.lsp.buf
  local diag = vim.diagnostic
  local telescope = require("telescope.builtin")

  local function buf_nmap(lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    nmap(lhs, rhs, opts)
  end

  local function diag_goto(next, severity)
    local go = next and diag.goto_next or diag.goto_prev
    severity = severity and diag.severity[severity] or nil
    return function() go({ severity = severity }) end
  end

  -- buf_nmap("gd", lsp.definition, { desc = "Goto definition" })
  -- buf_nmap("gr", function() lsp.references({}) end, { desc = "Goto References" })
  -- buf_nmap("gi", lsp.implementation, { desc = "Goto implementation" })
  -- buf_nmap("<leader>lD", lsp.type_definition, { desc = "Type definition" })

  buf_nmap("<leader>rn", lsp.rename, { desc = "Rename" })
  buf_nmap("<leader>ca", lsp.code_action, { desc = "Code action" })

  buf_nmap("gd", telescope.lsp_definitions, { desc = "Goto definition" })
  buf_nmap("gr", telescope.lsp_references, { desc = "Goto References" })
  buf_nmap("gi", telescope.lsp_implementations, { desc = "Goto implementation" })
  buf_nmap("<leader>ds", telescope.lsp_document_symbols, { desc = "Document symbols" })
  buf_nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

  buf_nmap("<leader>fd", telescope.diagnostics, { desc = "Find diagnostics" })
  buf_nmap("<leader>dl", diag.setloclist, { desc = "Open diagnostics list" })
  buf_nmap("<space>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
  buf_nmap("<leader>dm", diag.open_float, { desc = "Open floating diagnostic message" })
  buf_nmap("]d", diag_goto(true), { desc = "Next diagnostic" })
  buf_nmap("[d", diag_goto(false), { desc = "Prev diagnostic" })
  buf_nmap("]w", diag_goto(true, "WARN"), { desc = "Next warning" })
  buf_nmap("[w", diag_goto(false, "WARN"), { desc = "Prev warning" })
  buf_nmap("]e", diag_goto(true, "ERROR"), { desc = "Next error" })
  buf_nmap("[e", diag_goto(false, "ERROR"), { desc = "Prev error" })

  -- Lesser used LSP functionality
  buf_nmap("K", lsp.hover, { desc = "Hover Documentation" })
  buf_nmap("gD", lsp.declaration, { desc = "Goto declaration" })
  buf_nmap("gt", telescope.lsp_type_definitions, { desc = "Goto type definitions" })
  buf_nmap("<leader>lh", lsp.signature_help, { desc = "Signature documentation" })
  buf_nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Workspace add folder" })
  buf_nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Workspace remove folder" })
  -- stylua: ignore
  buf_nmap("<leader>wl", function() print(vim.inspect(lsp.list_workspace_folders())) end, { desc = "Workspace list folders" })

  buf_nmap("<space>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
  buf_nmap("<space>lI", "<cmd>Mason<cr>", { desc = "Open Mason" })
end

function M.plugin_telescope()
  local mod = require("telescope.builtin")
  local find_git_root = Util.find_git_root

  -- Git
  nmap("<leader>Gb", function() mod.git_branches({ use_file_path = true }) end, { desc = "Git branches" })
  nmap("<leader>gC", function() mod.git_commits({ use_file_path = true }) end, { desc = "Git commits (repository)" })
  nmap("<leader>GC", function() mod.git_bcommits({ use_file_path = true }) end, { desc = "Git commits (current file)" })
  nmap("<leader>gt", function() mod.git_status({ use_file_path = true }) end, { desc = "Git status" })

  nmap("<leader>f<cr>", mod.resume, { desc = "Resume previous search" })
  nmap("<C-p>", function() mod.find_files({ search_dirs = { find_git_root() } }) end, { desc = "Find files" })
  nmap("<leader>ff", function() mod.find_files({ search_dirs = { find_git_root() } }) end, { desc = "Find files" })
  nmap("<leader>f/", mod.current_buffer_fuzzy_find, { desc = "Find words in current buffer" })
  nmap("<leader><space>", mod.buffers, { desc = "Find buffers" })
  nmap("<leader>fb", mod.buffers, { desc = "Find buffers" })
  nmap("<leader>fw", mod.grep_string, { desc = "Find word under cursor" })
  nmap("<leader>fs", function() mod.live_grep({ search_dirs = { find_git_root() } }) end, { desc = "Find by grep" })
  nmap(
    "<leader>fF",
    function() mod.find_files({ search_dirs = { find_git_root() }, hidden = true, no_ignore = true }) end,
    { desc = "Find all files" }
  )
  nmap(
    "<leader>fS",
    function() mod.live_grep({ search_dirs = { find_git_root() }, hidden = true, no_ignore = true }) end,
    { desc = "Find by grep all files" }
  )
  nmap("<leader>f'", mod.marks, { desc = "Find marks" })
  nmap("<leader>fh", mod.help_tags, { desc = "Find help" })
  nmap("<leader>ft", mod.builtin, { desc = "Find telescope commands" })
  nmap("<leader>fC", mod.commands, { desc = "Find commands" })
  nmap("<leader>fk", mod.keymaps, { desc = "Find keymaps" })
  nmap("<leader>fm", mod.man_pages, { desc = "Find man" })
  nmap("<leader>f?", mod.oldfiles, { desc = "Find recently opened files" })
  nmap("<leader>fo", mod.oldfiles, { desc = "Find recently opened files" })
  nmap("<leader>fR", mod.registers, { desc = "Find registers" })
end

function M.plugin_cmp()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local function has_copilot()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  end

  local function cmp_tab(fallback)
    if cmp.visible() then
      cmp.select_next_item(has_copilot() and { behavior = cmp.SelectBehavior.Select } or {})
      return
    end

    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
      return
    end

    if has_words_before() then
      cmp.complete()
      return
    end

    fallback()
  end

  local function cmp_stab(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
      return
    end

    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
      return
    end

    fallback()
  end

  local function cmp_cr(fallback)
    if cmp.visible() then
      local confirm_opts = {
        select = false,
        behavior = cmp.ConfirmBehavior.Replace,
      }

      local is_insert_mode = function() return vim.api.nvim_get_mode().mode:sub(1, 1) == "i" end
      if is_insert_mode() then -- prevent overwriting brackets
        confirm_opts.behavior = cmp.ConfirmBehavior.Insert
      end

      local entry = cmp.get_selected_entry()
      local is_copilot = entry and entry.source.name == "copilot"
      if is_copilot then confirm_opts.behavior = cmp.ConfirmBehavior.Replace end

      if cmp.confirm(confirm_opts) then
        return -- success, exit early
      end
    end
    fallback() -- if not exited early, always fallback
  end

  return cmp.mapping.preset.insert({
    ["<C-c>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.config.diable,
    ["<C-y>"] = cmp.mapping({
      i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
        else
          fallback()
        end
      end,
    }),
    ["<Tab>"] = cmp.mapping(cmp_tab, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(cmp_stab, { "i", "s" }),
    ["<CR>"] = cmp.mapping(cmp_cr),
    -- ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
    ["<C-CR>"] = function(fallback)
      cmp.abort()
      fallback()
    end,
  })
end

function M.init()
  M._which_key()
  M._common()
  M._comment()
  M._git()
  M._paste()
  M._tmux()
end

return M
