-- Lazy configuration
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin management
local lfs = require("lfs")
local plugins = {}
local path = vim.fn.stdpath("config") .. "/lua/plugins"

for file in lfs.dir(path) do
    if file:match("%.lua$") and file ~= "init.lua" then
        local module_name = file:gsub("%.lua$", "")
        table.insert(plugins, require("plugins." .. module_name))
    end
end

require("lazy").setup(plugins)
