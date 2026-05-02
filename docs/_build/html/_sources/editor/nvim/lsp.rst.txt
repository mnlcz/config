Language Server Protocol
========================

This section documents the Language Server Protocol (LSP) configuration.

Overview
--------

LSP support is configured using native Neovim capabilities, with each
language server defined in its own module under:

``editor/nvim/lsp/``

Language servers are installed manually via a dedicated script:

``scripts/install_lsps.sh``

This script handles:

- Package manager installations (pnpm, system packages)
- Downloading prebuilt binaries
- Installing language-specific servers

Structure
---------

Each file in this directory corresponds to a specific language server.

Supported Servers
-----------------

.. contents::
   :local:

.. _lsp-bashls:

Bash (bashls)
~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/bashls.lua``

Installation
^^^^^^^^^^^^

Installed via ``pnpm``:

.. code-block:: bash

   pnpm add -g bash-language-server

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/bashls.lua
   :language: lua


.. _lsp-css-html-json:

CSS / HTML / JSON (vscode-langservers-extracted)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Configuration files:**

- ``cssls.lua``
- ``html.lua``
- ``jsonls.lua``

Installation
^^^^^^^^^^^^

Installed via ``pnpm``:

.. code-block:: bash

   pnpm add -g vscode-langservers-extracted

This provides:

- ``vscode-css-language-server``
- ``vscode-html-language-server``
- ``vscode-json-language-server``

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/cssls.lua
   :language: lua


.. _lsp-ts:

TypeScript (ts_ls)
~~~~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/ts_ls.lua``

Installation
^^^^^^^^^^^^

Installed via ``pnpm``:

.. code-block:: bash

   pnpm add -g typescript typescript-language-server

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/ts_ls.lua
   :language: lua


.. _lsp-lua:

Lua (lua_ls)
~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/lua_ls.lua``

Installation
^^^^^^^^^^^^

Downloaded from GitHub releases and installed manually:

.. code-block:: bash

   curl -LO https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-<version>-linux-x64.tar.gz
   sudo mkdir -p /usr/local/src/lua-language-server
   sudo tar xzf lua-language-server-*.tar.gz -C /usr/local/src/lua-language-server/
   sudo ln -sf /usr/local/src/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/lua_ls.lua
   :language: lua


.. _lsp-php:

PHP (phpactor)
~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/phpactor.lua``

Installation
^^^^^^^^^^^^

Downloaded as a PHAR and installed system-wide:

.. code-block:: bash

   curl -LO https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
   sudo install -m 755 phpactor.phar /usr/local/bin/phpactor

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/phpactor.lua
   :language: lua


.. _lsp-c3:

C3 (c3lsp)
~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/c3_lsp.lua``

Installation
^^^^^^^^^^^^

Downloaded and extracted from GitHub releases:

.. code-block:: bash

   curl -LO https://github.com/pherrymason/c3-lsp/releases/latest/download/c3lsp-linux-amd64.tar.gz
   tar xzf c3lsp-linux-amd64.tar.gz
   sudo install -m 755 server/bin/release/c3lsp /usr/local/bin/c3lsp

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/c3_lsp.lua
   :language: lua


.. _lsp-clangd:

C/C++ (clangd)
~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/clangd.lua``

Installation
^^^^^^^^^^^^

Installed via system package manager:

.. code-block:: bash

   sudo dnf install clang-tools-extra

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/clangd.lua
   :language: lua


.. _lsp-python:

Python (pylsp)
~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/pylsp.lua``

Installation
^^^^^^^^^^^^

Installed via ``pipx``:

.. code-block:: bash

   pipx install python-lsp-server

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/pylsp.lua
   :language: lua


.. _lsp-tex:

LaTeX (texlab)
~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/texlab.lua``

Installation
^^^^^^^^^^^^

Install via system package manager or distribution-specific method.

.. note::

   This server is not managed by the install script and may vary by system.

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/texlab.lua
   :language: lua


.. _lsp-tinymist:

Typst (tinymist)
~~~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/tinymist.lua``

Installation
^^^^^^^^^^^^

Downloaded from GitHub releases:

.. code-block:: bash

   curl -LO https://github.com/Myriad-Dreamin/tinymist/releases/latest/download/tinymist-linux-x64
   sudo install -m 755 tinymist-linux-x64 /usr/local/bin/tinymist

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/tinymist.lua
   :language: lua


.. _lsp-marksman:

Markdown (marksman)
~~~~~~~~~~~~~~~~~~

**Configuration file:** ``editor/nvim/lsp/marksman.lua``

Installation
^^^^^^^^^^^^

.. note::

   Installation method not defined in the script.

Configuration
^^^^^^^^^^^^^

.. literalinclude:: ../../../editor/nvim/lsp/marksman.lua
   :language: lua


Notes
-----

- The script ``scripts/install_lsps.sh`` is the authoritative source for installation.
- Some servers are grouped under shared packages (e.g. ``vscode-langservers-extracted``).
- Ensure required tools are installed:

  - ``pnpm``
  - ``curl``
  - ``tar``
  - ``pipx``

- The ``pnpm`` global bin directory must be present in ``PATH``.
