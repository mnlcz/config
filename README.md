# Personal dotfiles and configurations

## Dependencies

### General

- Git
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

Compilers and stuff like that. For the most part tied to the Mason plugin, to see what is needed run:

```bash
:checkhealth mason
```

#### Misc

- [treesitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md): for latex treesitter.
- [lazygit](https://github.com/jesseduffield/lazygit): for the plugin.
- [glow](https://github.com/charmbracelet/glow): for the plugin.

## Notes

### Sync scripts

Both `Sync.ps1` and `sync.sh` are scripts relevant for my personal setup and should be ignored. 

#### Explanation for the curious

I use a couple of old Windows drives (ntfs) to store my repos and multimedia, considering these drives do not mount on their own on Linux (I don't know how to do it yet), I cannot use symlinks for critical configs like, for example, the window manager. For that reason I use the scripts, they pretty much copy those critical configs from the regular `~/.config/` path into here. The PowerShell one is kind of outdated.

