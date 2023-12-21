vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- See `:help vim.opt`
local opt = vim.opt

-- Ignore compiled files
opt.wildignore = "__pycache__"
opt.wildignore:append({ "*.o", "*~", "*.pyc", "*pycache*" })
opt.wildignore:append({ "Cargo.lock" })

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
-- opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Tab width
opt.softtabstop = 4 -- Backspace
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = false
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Separate vim plugins from neovim in case vim still in use

opt.breakindent = true
opt.showbreak = "   " -- Make it so that long lines wrap smartly
opt.linebreak = true

if vim.fn.has("nvim-0.10") == 1 then opt.smoothscroll = true end

-- Folding
vim.opt.foldlevel = 99
vim.opt.foldtext = [[v:lua.require'util.ui'.foldtext()]]

if vim.fn.has("nvim-0.9.0") == 1 then vim.opt.statuscolumn = [[%!v:lua.require'util.ui'.statuscolumn()]] end

-- FIXME: causes freezes on <= 0.9, so only enable on >= 0.10 for now
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = [[v:lua.require'util.ui'.foldexpr()]]
else
  vim.opt.foldmethod = "indent"
end

do
  -- Cursorline highlighting control
  -- Only have it on in the active buffer
  local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
  local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
      group = group,
      pattern = pattern,
      callback = function() vim.opt_local.cursorline = value end,
    })
  end
  set_cursorline("WinLeave", false)
  set_cursorline("WinEnter", true)
  set_cursorline("FileType", false, "TelescopePrompt")
end

vim.o.formatexpr = [[v:lua.require'lazyvim.util.format'.formatexpr()]]

-- /usr/share/nvim/runtime/plugin/
local disabled_builtins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
  "vimball",
  "vimballPlugin",
}

for _, plugin in ipairs(disabled_builtins) do
  vim.g["loaded_" .. plugin] = 1
end
