Shells
======

This section documents shell configuration and environment setup.

Overview
--------

The shell environment is primarily based on Bash, with modular configuration
split across multiple files.

The setup includes:

- POSIX environment initialization (``.profile``)
- Interactive shell configuration (``.bashrc``)
- Modular scripts under ``.bashrc.d/``
- Additional configuration for other environments (e.g. Windows)

Entry Points
------------

.profile
~~~~~~~~

The main environment entry point.

Responsibilities:

- Defines base ``PATH``
- Sets up Plan 9 environment
- Sources selected modules from ``.bashrc.d/``

.. literalinclude:: ../../shells/.profile
   :language: bash
   :linenos:

.bashrc
~~~~~~~

Interactive shell configuration.

Used to:

- Export general-purpose variables
- Initialize tools not tied to specific modules

.. note::

   This file acts as a thin entry point and delegates most logic to
   ``.bashrc.d/``.

Modules (.bashrc.d)
-------------------

Configuration is split into focused modules:

0dirs.sh
~~~~~~~~

Defines commonly used directories as environment variables.

Examples:

- ``$PROJ``: projects directory
- ``$SCRIPTS``: scripts directory

aliases.sh
~~~~~~~~~~

Defines shell aliases for:

- System commands
- Frequently used tools

dev.sh
~~~~~~

Development environment setup.

Responsibilities:

- Exports variables for tools such as:
  - Composer
  - pnpm
  - Cargo
- Initializes development workflows
- Launches tmux via:

  - :doc:`../scripts/index` (``init-tmux.sh``)

plan9.sh
~~~~~~~~

Initializes the Plan 9 from User Space environment.

Responsibilities include:

- Setting ``NAMESPACE``
- Mounting required filesystems
- Starting services (e.g. ``plumber``, ``fontsrv``)
- Providing the ``acme()`` helper function

.. literalinclude:: ../../shells/.bashrc.d/plan9.sh
   :language: bash

See also:

- :doc:`../editor/acme`

Readline Configuration
---------------------

inputrc
~~~~~~~

Configuration for readline-compatible programs (e.g. Bash).

.. literalinclude:: ../../shells/inputrc
   :language: bash
   :linenos:

Key features:

- Vi editing mode
- Reduced escape timeout
- Cursor shape changes depending on mode

Other Environments
------------------

profile.ps1
~~~~~~~~~~~

PowerShell configuration for Windows environments.

.. note::

   This is separate from the main Linux-based setup and is not tightly integrated.

Themes
------

custom-themes/
~~~~~~~~~~~~~~

Contains prompt/theme definitions.

These are used by external prompt tools (e.g. Oh My Posh).

Notes
-----

- Configuration is modular and intentionally minimal.
- Environment variables and paths are centralized in dedicated modules.
- Shell setup integrates tightly with:

  - :doc:`../scripts/index`
  - :doc:`../editor/index`
  - :doc:`../term/index`