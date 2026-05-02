Scripts
=======

This section documents utility scripts used across the configuration.

Overview
--------

The scripts are implemented using a combination of:

- Shell scripts (system integration, bootstrapping)
- PHP scripts (primary scripting language)

The directory is structured as a small Composer project:

- ``scripts/src/``: PHP scripts
- ``scripts/vendor/``: dependencies (ignored in version control)
- standalone shell scripts for system tasks

Design
------

The scripting approach follows these principles:

- Prefer PHP for non-trivial logic
- Use shell scripts for system interaction and orchestration
- Keep scripts small, focused, and composable
- Centralize reusable logic via Composer when needed

This allows more complex workflows to be implemented in PHP while still
integrating cleanly with the system.

Usage
-----

Most scripts are intended to be executed directly:

.. code-block:: bash

   ./scripts/<script-name>

Some scripts are designed to be used indirectly (e.g. via desktop entries
or other scripts).

Script Index
------------

.. contents::
   :local:

PHP Scripts
-----------

bw-unlock
~~~~~~~~~

**Path:** ``scripts/src/bw-unlock.php``

Interactively unlocks the Bitwarden CLI session and exports the session
key as an environment variable.

cf
~~

**Path:** ``scripts/src/cf.php``

Formatting helper intended for use within the Acme workflow.

- Detects the current filetype
- Applies the corresponding formatter

See also:

- :doc:`../editor/acme`

gbsavesync
~~~~~~~~~~

**Path:** ``scripts/src/gbsavesync.php``

Synchronizes emulator save files across different tools.

- Supports VBA-M and RetroArch
- Uses external conversion tool

updates
~~~~~~~

**Path:** ``scripts/src/updates.php``

Checks for available updates across multiple package managers.

Examples include:

- ``dnf``
- ``cargo``

Shell Scripts
-------------

gnome-save-keybindings.sh
~~~~~~~~~~~~~~~~~~~~~~~~~

Saves current GNOME keybindings to:

- ``wm/mutter``

gnome-restore-keybindings.sh
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Restores GNOME keybindings from:

- ``wm/mutter``

init-tmux.sh
~~~~~~~~~~~~

Initializes a tmux session with predefined windows and layout.

See also:

- :doc:`../term/index`

install-formatters
~~~~~~~~~~~~~~~~~~

Installs formatting tools used across the configuration.

- Assumes RHEL-like systems

install-lsps
~~~~~~~~~~~~

Installs Language Server Protocol (LSP) servers.

- Assumes RHEL-like systems
- Handles multiple installation methods (npm/pnpm, binaries, system packages)

See also:

- :doc:`../editor/nvim/lsp`

install-systools
~~~~~~~~~~~~~~~~

.. note::

   This script is currently incomplete.

Intended to install general system utilities.

launch-acme.sh
~~~~~~~~~~~~~~

Wrapper script used to launch Acme in a graphical environment.

- Loads environment variables
- Initializes Plan 9 services
- Restores editor layout

See also:

- :doc:`../editor/acme`

Notes
-----

- The ``vendor/`` directory is excluded from version control.
- PHP dependencies are managed via Composer.
- Some scripts assume specific system environments (e.g. RHEL-based distributions).