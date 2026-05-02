Overview
========

This repository contains a modular configuration for a Linux-based
development environment.

It combines:

- Editor configuration
- Shell environment
- Window manager setup
- Supporting tools and scripts

The goal is to provide a cohesive, reproducible workflow while keeping
each component independent and easy to modify.

Architecture
------------

The system can be understood as:

- ``shells/`` defines the environment (PATH, variables, services)
- ``scripts/`` automate tasks and system setup
- ``tools/`` provide supporting functionality (tmux, fastfetch)
- ``editor/`` defines the editing experience (Neovim, Acme)
- ``wm/`` controls window management and system behavior
- ``term/`` provides the terminal interface

Key Components
--------------

Editor
~~~~~~

- Neovim with Lua-based configuration
- Manual LSP management
- Minimal plugin usage (via ``vim.pack``)
- Acme

Shell Environment
~~~~~~~~~~~~~~~~~

- Bash-based, modular configuration
- Environment split across ``.bashrc.d/``
- Integration with development tools and tmux

Window Manager
~~~~~~~~~~~~~~

- Primary: dwl (Wayland compositor)
- Secondary: GNOME Mutter (fallback)

Includes:

- Custom patches
- Status bar (dwlb)
- Menu system (bemenu)
- Notification daemon (mako)

Scripts
~~~~~~~

- Combination of shell and PHP
- PHP used for more complex logic
- Includes installers, automation, and utilities

Tools
~~~~~

- tmux for session management
- fastfetch for system information

Templates
~~~~~~~~~

- LaTeX and Typst document templates
- Reusable configuration files
- Symlink-based workflow for Typst packages

Notes
-----

- Many components assume a Linux environment (RHEL-based in some cases)
- Some configurations rely on external tools being installed
- System paths (e.g. ``/usr/local/src``) are used for certain components