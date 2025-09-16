# Personal dotfiles and configurations

## Dependencies

### General

- Git
- Curl
- [Rustup](https://rustup.rs/) for Alacritty (configured as default terminal).

### Neovim

#### LuaRocks

Required for a couple of plugins. Check if the system's version and the Neovim's versions match. If they don't, try to install the Neovim's version and install packages with the flag:

```bash
sudo luarocks install SOMETHING --lua-version=5.1
```

The needed packages are:

- `luafilesystem`: needed for dynamically handling the plugins. See how I [load the plugins](nvim/lua/plugins/init.lua).

#### Dev tools

I'm no using Mason, I prefer to install my tools via package managers.
- For lsp: [lsp configured](nvim/lsp/)
- For formatters: [conform config](nvim/lua/plugins.lua)

#### Misc

- [fd](https://github.com/sharkdp/fd): optional for Telescope.
- [glow](https://github.com/charmbracelet/glow): for the plugin (if used).
- [jsregexp](https://github.com/kmarius/jsregexp): optional for luasnip (can be installed with luarocks).
- [lazygit](https://github.com/jesseduffield/lazygit): for the plugin.
- [ripgrep](https://github.com/BurntSushi/ripgrep): recommended for Telescope.
- [treesitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md): for latex treesitter.
- [vscode-codicons](https://github.com/microsoft/vscode-codicons): optional for lspkind (if not installed requires changing the `preset` value to `default`).

## Notes

### Sync scripts

Both `Sync.ps1` and `sync.sh` are scripts relevant for my personal setup and should be ignored. 

