#!/usr/bin/env python3
"""
make_nein_theme.py
Converts hevel's nein_cursor.h RGBA pixel data into an XCursor theme
that can be installed under ~/.local/share/icons/nein/.

Requirements: Python 3, Pillow (pip install Pillow --break-system-packages),
              xcursorgen (pkg install xcursorgen on FreeBSD)

Usage:
    python3 make_nein_theme.py [path/to/nein_cursor.h]

If no path is given, looks for nein_cursor.h in the current directory.
Output: ./nein-theme/ directory ready to copy to ~/.local/share/icons/nein/
"""

import sys
import os
import re
import shutil
import subprocess
from pathlib import Path

# ---------------------------------------------------------------------------
# Cursor metadata — mirrors nein_cursor_metadata[] from the header.
# (width, height, hotspot_x, hotspot_y, offset_in_pixels)
# ---------------------------------------------------------------------------
CURSORS = [
    {"name": "whitearrow", "w": 16, "h": 16, "hx": 0,  "hy": 0,  "off": 0},
    {"name": "boxcursor",  "w": 16, "h": 16, "hx": 7,  "hy": 7,  "off": 256},
    {"name": "crosscursor","w": 16, "h": 16, "hx": 7,  "hy": 7,  "off": 512},
    {"name": "sightcursor","w": 16, "h": 16, "hx": 7,  "hy": 7,  "off": 768},
    {"name": "t",          "w": 16, "h": 10, "hx": 7,  "hy": 6,  "off": 1024},
    {"name": "b",          "w": 16, "h": 10, "hx": 7,  "hy": 3,  "off": 1184},
]

# ---------------------------------------------------------------------------
# XCursor name mapping.
# ---------------------------------------------------------------------------
XCURSOR_NAMES = {
    "whitearrow": [
        "left_ptr",
        "default",
        "arrow",
        "top_left_arrow",
        "pointer",
        # text
        "xterm",
        "text",
        "ibeam",
    ],
    "boxcursor": [
        # move/grab
        "fleur",
        "grabbing",
        "grab",
        "move",
        # loading
        "watch",
        "wait",
        "progress",
    ],
    "crosscursor": [
        # selection (slurp etc.)
        "crosshair",
        "cross",
        "tcross",
        # misc
        "plus",
        "cell",
    ],
    "sightcursor": [
        # horizontal resize
        "left_side",
        "right_side",
        "ew-resize",
        "w-resize",
        "e-resize",
        "size_hor",
        "sb_h_double_arrow",
        # target/dot
        "target",
        "dotbox",
        "dot",
    ],
    "t": [
        # vertical resize top
        "top_side",
        "n-resize",
        "ns-resize",
        "size_ver",
        "sb_v_double_arrow",
        # diagonal resize
        "nw-resize",
        "ne-resize",
        "nwse-resize",
    ],
    "b": [
        # vertical resize bottom
        "bottom_side",
        "s-resize",
        # diagonal resize
        "se-resize",
        "sw-resize",
        "nesw-resize",
    ],
}

SIZE = 24  # xcursor render size hint (actual image is 16x16)


def parse_header(path):
    """Extract the uint32_t array from nein_cursor.h."""
    text = Path(path).read_text()
    m = re.search(
        r"nein_cursor_data\[\]\s*=\s*\{(.*?)\};",
        text, re.DOTALL
    )
    if not m:
        sys.exit("ERROR: could not find nein_cursor_data[] in header")
    body = m.group(1)
    values = [int(x, 16) for x in re.findall(r"0x[0-9a-fA-F]+", body)]
    return values


def pixels_to_png(data, cursor, out_path):
    """Render one cursor's RGBA pixel data to a PNG."""
    try:
        from PIL import Image
    except ImportError:
        sys.exit("ERROR: Pillow not found. Run: pip install Pillow --break-system-packages")

    w, h, off = cursor["w"], cursor["h"], cursor["off"]
    pixels = data[off: off + w * h]

    img = Image.new("RGBA", (w, h))
    raw = []
    for px in pixels:
        a = (px >> 24) & 0xFF
        r = (px >> 16) & 0xFF
        g = (px >> 8)  & 0xFF
        b =  px        & 0xFF
        raw.append((r, g, b, a))

    img.putdata(raw)
    img.save(str(out_path))


def write_cursor_cfg(cfg_path, png_name, cursor):
    """Write the xcursorgen config file for one cursor image."""
    hx, hy = cursor["hx"], cursor["hy"]
    cfg_path.write_text(f"{SIZE} {hx} {hy} {png_name}\n")


def run_xcursorgen(cfg_path, out_path):
    """Run xcursorgen to produce the binary XCursor file."""
    result = subprocess.run(
        ["xcursorgen", str(cfg_path), str(out_path)],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"  WARNING: xcursorgen failed for {cfg_path.name}: {result.stderr.strip()}")
        return False
    return True


def main():
    header_path = sys.argv[1] if len(sys.argv) > 1 else "nein_cursor.h"
    if not Path(header_path).exists():
        sys.exit(f"ERROR: {header_path} not found")

    if not shutil.which("xcursorgen"):
        sys.exit("ERROR: xcursorgen not found. Install with: pkg install xcursorgen")

    print(f"Parsing {header_path}...")
    data = parse_header(header_path)
    print(f"  Read {len(data)} pixel values")

    theme_dir = Path("nein-theme")
    cursors_dir = theme_dir / "cursors"
    tmp_dir = theme_dir / "_tmp"
    cursors_dir.mkdir(parents=True, exist_ok=True)
    tmp_dir.mkdir(exist_ok=True)

    (theme_dir / "index.theme").write_text(
        "[Icon Theme]\n"
        "Name=nein\n"
        "Comment=Plan 9 cursor set from hevel\n"
    )

    print("Converting cursors...")
    for cursor in CURSORS:
        name = cursor["name"]
        png_path = tmp_dir / f"{name}.png"
        cfg_path = tmp_dir / f"{name}.cfg"
        xcursor_path = cursors_dir / name

        pixels_to_png(data, cursor, png_path)
        write_cursor_cfg(cfg_path, str(png_path.resolve()), cursor)

        if run_xcursorgen(cfg_path, xcursor_path):
            print(f"  {name} -> cursors/{name}")
        else:
            print(f"  {name} -> FAILED (check xcursorgen output)")

        for alias in XCURSOR_NAMES.get(name, []):
            link = cursors_dir / alias
            if link.exists() or link.is_symlink():
                link.unlink()
            link.symlink_to(name)
            print(f"    symlink: {alias} -> {name}")

    shutil.rmtree(tmp_dir)

    print()
    print("Done. Theme directory: ./nein-theme/")
    print()
    print("To install:")
    print("  cp -r nein-theme ~/.local/share/icons/nein")
    print()
    print("Then set in your environment:")
    print("  XCURSOR_THEME=nein")
    print("  XCURSOR_SIZE=16")


if __name__ == "__main__":
    main()