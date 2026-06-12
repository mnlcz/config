# Patching `foot` via FreeBSD port

1. Copy patch files to `/usr/ports/x11/foot/files` without the `.patch` extension and with a `patch-` prefix.
2. Running `make` automatically applies the patches.

## Example

```sh
cp $CONF/term/foot/patches/01-plan9-scrollbar.patch /usr/ports/x11/foot/files/patch-plan9-scrollbar
cp $CONF/term/foot/patches/02-plan9-scrollbar-input.patch /usr/ports/x11/foot/files/patch-plan9-scrollbar-input
make -C /usr/ports/x11/foot install clean
```
