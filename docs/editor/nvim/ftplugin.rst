Filetype-specific Configuration
==============================

This section documents filetype-specific behavior.

Neovim allows per-filetype customization through the ``ftplugin`` mechanism,
where settings are applied automatically based on the detected filetype.

In this configuration, each supported filetype has its own Lua module under:

``editor/nvim/ftplugin/``

Overview
--------

The following filetypes are currently customized:

- C3
- Markdown
- PHP
- LaTeX

Each module is loaded automatically when a buffer with the corresponding
filetype is opened.

C3
--

Configuration for the C3 language.

.. literalinclude:: ../../../editor/nvim/ftplugin/c3.lua
   :language: lua

Markdown
--------

Configuration for Markdown files.

.. literalinclude:: ../../../editor/nvim/ftplugin/markdown.lua
   :language: lua

PHP
---

Configuration for PHP files.

.. literalinclude:: ../../../editor/nvim/ftplugin/php.lua
   :language: lua

LaTeX
-----

Configuration for LaTeX files.

.. literalinclude:: ../../../editor/nvim/ftplugin/tex.lua
   :language: lua

Notes
-----

- All settings in this directory are applied **buffer-locally**.
- This ensures that language-specific behavior does not leak into other filetypes.
- More advanced language features (such as LSP integration) are documented
  separately in the LSP section.