# Notes

The libraries under `../lib` have `c3l` packaged libraries that lack the `freebsd-x64` entry in their `manifest.json`.

First, get in the work directory:

```sh
# cd <PATH_TO_C3FMT>
mkdir -p _FIXLIBS_NOTES
cd _FIXLIBS_NOTES
```

## `tree_sitter.c3l`

Unpack the base library:

```sh
unzip ../lib/tree_sitter.c3l
```

Fix `manifest.json`.

```sh
v manifest.json
```

Repack the fix:

```sh
rm -f ../lib/tree_sitter.c3l
tar --format zip -cf ../lib/tree_sitter.c3l *
```

Verify the change on the packed library:

```sh
unzip -p ../lib/tree_sitter.c3l manifest.json
```

## `tree_sitter_c3.c3l`

Clear the work dir:

```sh
# cd <PATH_TO_C3FMT>/_FIXLIB
rm -rf ./*
```

Unpack the base library:

```sh
unzip ../lib/tree_sitter_c3.c3l
```

Fix `manifest.json`.

```sh
v manifest.json
```

Repack the fix:

```sh
rm -f ../lib/tree_sitter_c3.c3l
tar --format zip -cf ../lib/tree_sitter_c3.c3l *
```

Verify the change on the packed library:

```sh
unzip -p ../lib/tree_sitter_c3.c3l manifest.json
```

## Build

Go to the repo's directory:

```sh
# cd <PATH_TO_C3FMT>
```

Build, specifying library path since BSD uses a different location from what `c3c` expects.

```sh
c3c build -L /usr/local/lib
```

## Install

```sh
doas ln -sf /usr/local/src/c3fmt-<VERSION>/build/c3fmt /usr/local/bin/c3fmt
```
