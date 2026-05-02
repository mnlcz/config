Core Configuration
==================

This section documents the core configuration of **Neovim**.

The setup follows a modular structure, where each concern (options, mappings, etc.)
is isolated into its own Lua module and loaded from the main entry point.

Overview
--------

The configuration is organized as follows:

- ``init.lua``: entry point, responsible for bootstrapping the configuration
- ``lua/options.lua``: editor options
- ``lua/mappings.lua``: key mappings
- ``lua/autocmds.lua``: autocommands
- ``lua/statusline.lua``: UI/statusline configuration

Initialization
--------------

The main entry point loads all core modules and sets up the environment.

.. literalinclude:: ../../../editor/nvim/init.lua
   :language: lua

Options
-------

This module defines the base editor behavior, including UI, indentation,
search, and general usability settings.

.. literalinclude:: ../../../editor/nvim/lua/options.lua
   :language: lua

Key Mappings
------------

Custom key mappings are defined separately to keep the configuration
declarative and easy to modify.

.. literalinclude:: ../../../editor/nvim/lua/mappings.lua
   :language: lua

Autocommands
------------

Autocommands are used to define dynamic behavior triggered by events.

.. literalinclude:: ../../../editor/nvim/lua/autocmds.lua
   :language: lua

Statusline
----------

The statusline configuration customizes how information is displayed
in the editor UI.

.. literalinclude:: ../../../editor/nvim/lua/statusline.lua
   :language: lua

Notes
-----

- This structure makes it easier to extend or replace individual parts
  without affecting the rest of the configuration.
- Plugin-specific behavior is kept outside of this section and documented
  separately.