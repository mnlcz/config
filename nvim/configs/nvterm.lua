local options = {
  terminals = {
    -- shell = vim.o.shell, -- default
    shell = "pwsh",
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.2,
        col = 0.25,
        width = 0.5,
        height = 0.6,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.3 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
    },
  },
  behavior = {
    autoclose_on_quit = {
      enabled = false,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = true,
  },
}

require("nvterm").setup(options)
