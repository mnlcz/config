# Personal dotfiles and configurations

The `Sync.ps1` script updates the repo with the latest changes of the configs that don't use symlinks (mainly i3 and the Windows ones).

## Dependencies

### General

- Git
- Powershell (personal favorite)
- [Rustup](https://rustup.rs/) for Alacritty (configured as default terminal for i3).

### Neovim

- `luarocks`: for a couple of plugins.
- `luafilesystem`: needed for dynamically handling the plugins. See how I [load the plugins](nvim/lua/plugins/init.lua).

