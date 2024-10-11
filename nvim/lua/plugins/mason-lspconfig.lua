return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
        local masonlsp = require("mason-lspconfig")

        masonlsp.setup({
            ensure_installed = {
                -- Important
                "lua_ls", "texlab", "marksman", "zls", "clangd",
                -- Extra servers
                "jdtls", "html", "cssls", "perlnavigator", "solargraph", "pylsp", "ts_ls",
            },
        })

        masonlsp.setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup {}
            end,

            -- Overrides
            -- Recommended setup for using Lua for Neovim
            ["lua_ls"] = function()
                require 'lspconfig'.lua_ls.setup {
                    on_init = function(client)
                        if client.workspace_folders then
                            local path = client.workspace_folders[1].name
                            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                                return
                            end
                        end

                        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                            runtime = {
                                -- Tell the language server which version of Lua you're using
                                -- (most likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT'
                            },
                            -- Make the server aware of Neovim runtime files
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME
                                    -- Depending on the usage, you might want to add additional paths here.
                                    -- "${3rd}/luv/library"
                                    -- "${3rd}/busted/library",
                                }
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                -- library = vim.api.nvim_get_runtime_file("", true)
                            }
                        })
                    end,
                    settings = {
                        Lua = {}
                    }
                }
            end
        }
    end
}
