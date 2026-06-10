# Note

Experimental editor, [ad](https://github.com/sminez/ad).

## Installation (personal)

- Install via [crates.io](https://crates.io/crates/ad-editor) didn't work for me.
- Install via release tar didn't work either.
- Manual install via clone and `cargo` worked.

```bash
cd /usr/local/src
git clone git@github.com:sminez/ad.git
cd ad
cargo install --path .
cargo xtask setup-dotfiles
```

Last command generates dotfiles. `$CONF` repo has my own `config.toml`. The symlink:

```bash
ln -sf $CONF/editor/ad/config.toml $HOME/.ad/config.toml
```
