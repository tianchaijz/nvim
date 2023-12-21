-- https://gist.github.com/yudai/95b20e3da66df1b066531997f982b57b
-- https://github.com/mobile-shell/mosh/pull/1054

--[[
mosh: 1.4.0
tmux: 3.3a
  set -g set-clipboard on
  set -g allow-passthrough on
  set -ag terminal-overrides ",xterm-256color:Ms=\\E]52;c;%p2%s\\7"
kitty:
  clipboard_control write-clipboard write-primary read-clipboard-ask read-primary-ask
--]]

return {
  "ojroques/nvim-osc52",
  opts = {
    max_length = 0, -- Maximum length of selection (0 for no limit)
    silent = false, -- Disable message on successful copy
    trim = false, -- Trim surrounding whitespaces before copy
    tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
  },

  config = function(_, opts)
    require("osc52").setup(opts)
    require("keymaps").plugin_osc52()
  end,
}
