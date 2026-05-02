Acme
====

This section documents the setup for Acme.

Overview
--------

The configuration is split across three components:

- Layout definition (``acme.dump``)
- Environment setup (``shells/.bashrc.d/plan9.sh``)
- Launch script (``scripts/launch-acme.sh``)

This separation allows the editor state, runtime environment, and launch
mechanism to evolve independently.

Layout
------

The file ``editor/acme.dump`` defines the editor layout and session state.

It is loaded at startup to restore:

- Window arrangement
- Open files
- Buffer state

.. note::

   This file is a snapshot of a running session and is not meant to be
   edited manually.

Environment
-----------

The Plan 9 environment required by Acme is initialized via:

``shells/.bashrc.d/plan9.sh``

This defines a helper function:

- ``acme()``

Responsibilities include:

- Mounting required 9p filesystems (``/mnt/acme``, ``/mnt/font``)
- Starting required services:
  - ``fontsrv``
  - ``plumber``
- Setting ``NAMESPACE``
- Loading plumbing rules
- Launching Acme with appropriate flags

.. literalinclude:: ../../shells/.bashrc.d/plan9.sh
   :language: bash

.. note::

   This function was my original method for launching Acme directly
   from the terminal.

Launch Method
-------------

My preferred way to launch Acme is via:

``scripts/launch-acme.sh``

This script is designed to be used from a desktop entry rather than
invoked manually.

Responsibilities:

- Ensures environment variables are loaded (via ``.profile``)
- Sets ``DISPLAY`` if needed
- Recreates required mount points
- Starts ``fontsrv`` and ``plumber`` if not running
- Loads plumbing rules
- Launches Acme with the configured layout

.. literalinclude:: ../../scripts/launch-acme.sh
   :language: bash

Key difference from the shell function:

- Uses ``-l <dump>`` to restore layout automatically
- Integrates better with graphical session startup

Desktop Entry
-------------

Acme is launched through a desktop entry similar to:

.. code-block:: ini

   [Desktop Entry]
   Name=Acme
   Exec=/path/to/repo/scripts/launch-acme.sh
   Type=Application
   Categories=Development;

This allows integration with application launchers and window managers.

Notes
-----

- This setup assumes a working Plan 9 from User Space environment.
- ``fusermount`` (or equivalent) must be available and properly configured.
- The mount points ``/mnt/acme`` and ``/mnt/font`` are recreated on each launch.
- The launch script is the authoritative entry point; the shell function is
  kept for reference and fallback usage.