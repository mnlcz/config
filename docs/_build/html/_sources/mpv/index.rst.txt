MPV
===

This section documents the configuration for mpv.

Overview
--------

The configuration consists of two main files:

- ``mpv/mpv.conf``: core player configuration
- ``mpv/input.conf``: custom key bindings

These files are intended to be placed in:

- ``~/.config/mpv/``

Configuration
-------------

mpv.conf
~~~~~~~~

Defines the default behavior of the player, including:

- Video and audio settings
- Window behavior
- Playback options

.. literalinclude:: ../../mpv/mpv.conf
   :language: ini
   :linenos:

input.conf
~~~~~~~~~~

Defines custom key bindings for interacting with the player.

Typical uses include:

- Playback control
- Seeking
- Toggling options

.. literalinclude:: ../../mpv/input.conf
   :language: ini
   :linenos:

Notes
-----

- Defaults are preferred unless a specific behavior needs to be changed.
- Key bindings are customized to fit the overall workflow of the system.
- This configuration integrates with the window manager setup (e.g. floating behavior).