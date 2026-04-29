# dwl configuration

## Patches applied

1. `foreign-toplevel-management.patch` — enables the foreign toplevel management
   protocol so tools like `lswt` can query open windows and their app_id.
   Note: requires manual Makefile fix, see patch comments.

2. `switchlayout.patch` — adds `switchlayout(const Arg *arg)` function for
   switching XKB keyboard layout groups programmatically. Also writes the
   current layout name to `/tmp/dwl-layout` for status bar display.

## dwlb patches

1. `no-flicker.patch` — only redraws the status bar when content actually changes,
   eliminating flicker from frequent status updates.

## XKB customization

Custom symbols file: `xkb/custom` (symlinked to `/usr/share/X11/xkb/symbols/custom`)

The following line must be added to `/usr/share/X11/xkb/rules/evdev`
in the `! option = symbols` section (around line 726):

```
custom:nodead_circumflex_grave = +custom(nodead_circumflex_grave)
```

This makes AltGr+{ produce ^ and AltGr+} produce ` without dead key behavior.
While keeping the Spanish 'tilde' as a dead key.

## Notes

- `config.h` and `dwl.desktop` are symlinked.
- XWayland enabled in `config.mk`.
- `VERSIONS` file keeps track of the tools in use and their exact version.
- `PATCHES` file contains the patches applied in order.
