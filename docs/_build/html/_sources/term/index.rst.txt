Terminal
========

This section documents the terminal configuration.

Overview
--------

The setup uses `foot <https://codeberg.org/dnkl/foot>`_ as the primary terminal emulator.

Configuration is defined in:

- ``term/foot/foot.ini``

This file is intended to be placed in:

- ``~/.config/foot/foot.ini``

Configuration
-------------

foot.ini
~~~~~~~~

Defines the behavior and appearance of the terminal, including:

- Font configuration
- Colors and theme
- Window behavior
- Scrolling and input settings

.. literalinclude:: ../../term/foot/foot.ini
   :language: ini
   :linenos:

Notes
-----

- The configuration is minimal and relies mostly on sensible defaults.
- Font configuration may depend on system-installed fonts.
- Behavior may interact with the window manager (e.g. floating, sizing).

See also:

- :doc:`../wm/index`
- :doc:`../shells/index`