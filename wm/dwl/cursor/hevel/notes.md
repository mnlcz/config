# Hevel plan9's cursor

This is a port from hevel's cursor (defined in `nein_cursor.h`) to a real XCursor theme.

## Deps

1. xcursorgen. Installed via system's package manager.
2. Pillow. `pip install Pillow --break system packages`

## Run

Generate:

```sh
python3 make_nein_theme.py path/to/nein_cursor.h
```

Remove old version:

```sh
rm -rf ~/.local/share/icons/nein
```

Install new version:
```sh
cp -r nein-theme ~/.local/share/icons/nein
```

