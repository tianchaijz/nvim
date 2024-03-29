-- bootstrap -> options -> setup plugin -> keymaps | autocmds

-- Great examples:
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

require("bootstrap")
require("options")
require("util.plugin").setup()

require("lazy").setup({ { import = "plugins" } }, {
  change_detection = { enabled = false },
})

require("keymaps").init()
require("autocmds")
