Plugins
=======

This section documents the plugin system.

Overview
--------

Plugins are managed using Neovim's native package feature:

- ``vim.pack`` (built-in, no external plugin manager)

This configuration intentionally avoids third-party managers such as
``lazy.nvim`` in favor of a simpler and more transparent setup.

All plugin definitions and their configuration are centralized in:

``editor/nvim/lua/plugins.lua``

Design
------

The plugin system follows these principles:

- **Single file configuration**: all plugins and their setup live in one place
- **Reduced indirection**: avoids splitting configuration across many files
- **Gradual minimization**: plugins are used pragmatically and may be removed over time

This makes the setup easier to audit and refactor.

Plugin Installation
-------------------

Plugins are declared using ``vim.pack.add``:

.. code-block:: lua

   vim.pack.add({
       { src = "https://github.com/user/plugin" },
   })

Below is the current plugin list:

.. literalinclude:: ../../../editor/nvim/lua/plugins.lua
   :language: lua
   :start-after: vim.pack.add({
   :end-before: })
   :linenos:

Categories
----------

Plugins can be roughly grouped by their purpose:

UI / Appearance
^^^^^^^^^^^^^^^

- ``koda.nvim`` (light theme)
- ``black-metal-theme-neovim`` (dark theme)
- ``mini.icons`` (icons)
- ``lspkind.nvim`` (pictograms)

Editing
^^^^^^^

- ``nvim-autopairs`` (automatic bracket pairing)
- ``LuaSnip`` (snippets)

Navigation / Files
^^^^^^^^^^^^^^^^^^

- ``oil.nvim`` (file explorer)
- ``telescope.nvim`` (fuzzy finder)
- ``telescope-fzf-native.nvim`` (native fzf extension)

Language / Syntax
^^^^^^^^^^^^^^^^^

- ``nvim-treesitter``
- ``nvim-treesitter-textobjects``
- ``vimtex`` (LaTeX support)

Development Tools
^^^^^^^^^^^^^^^^^

- ``conform.nvim`` (formatting)
- ``gitsigns.nvim`` (git integration)
- ``todo-comments.nvim`` (highlight TODOs)
- ``compile-mode.nvim`` (compilation interface)

Utilities / Dependencies
^^^^^^^^^^^^^^^^^^^^^^^^

- ``plenary.nvim`` (utility library)
- ``render-markdown.nvim`` (inline markdown rendering)
- ``table-nvim`` (markdown table editing)

Configuration
-------------

After installation, each plugin is configured within the same file.

Rationale:

- Keeps all plugin-related logic in a single location
- Reduces context switching
- Makes dependencies and interactions easier to track

.. note::

   The configuration section of ``plugins.lua`` is intentionally not
   fully reproduced here, as it is large and subject to frequent change.

   Refer directly to the source file for implementation details.

Notes
-----

- Some plugins may be temporarily disabled or marked as not working.
- Native features of Neovim are preferred over plugins when possible.
- Over time, this setup aims to reduce reliance on external plugins.