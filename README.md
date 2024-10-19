# Personal dotfiles and configurations

The `Sync.ps1` script updates the repo with the latest changes of the configs that don't use symlinks (mainly i3 and the Windows ones).

## Dependencies

### General

- Git
- Powershell (personal favorite)
- [Rustup](https://rustup.rs/) for Alacritty (configured as default terminal for i3).

### Neovim

#### LuaRocks

Required for a couple of plugins. Check if the system's version and the Neovim's versions match. If they don't, try to install the Neovim's version and install packages with the flag:

```bash
sudo luarocks install SOMETHING --lua-version=5.1
```

The needed packages are:

- `luafilesystem`: needed for dynamically handling the plugins. See how I [load the plugins](nvim/lua/plugins/init.lua).

#### Dev tools

Compilers and stuff like that. For the most part tied to the Mason plugin, to see what is needed run:

```bash
:checkhealth mason
```

#### Misc

- [treesitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md): for latex treesitter.
- [lazygit](https://github.com/jesseduffield/lazygit): for the plugin.
- [glow](https://github.com/charmbracelet/glow): for the plugin.

