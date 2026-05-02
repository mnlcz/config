Tools
=====

This section documents configuration for supporting tools used across the system.

Overview
--------

The tools included here provide:

- System information display
- Terminal session management

Currently configured tools:

- fastfetch
- tmux

fastfetch
---------

Configuration files for fastfetch are located in:

- ``tools/fastfetch/``

These define different output styles depending on context, such as:

- Compact output
- Detailed reports
- Styled or themed layouts

Examples include:

- ``small.jsonc``
- ``medium.jsonc``
- ``big-fancy.jsonc``
- ``report.jsonc``

Default Configuration
~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/fastfetch/config.jsonc
   :language: json
   :linenos:

.. note::

   The configuration files use JSONC (JSON with comments), which is supported
   by fastfetch.

Usage
~~~~~

Different configurations can be selected manually, for example:

.. code-block:: bash

   fastfetch --config path/to/config.jsonc

tmux
----

The tmux configuration is defined in:

- ``tools/.tmux.conf``

.. literalinclude:: ../../tools/.tmux.conf
   :language: bash
   :linenos:

Responsibilities
~~~~~~~~~~~~~~~~

The configuration defines:

- Key bindings
- Session behavior
- Window and pane management

Integration
~~~~~~~~~~~

tmux is typically initialized via:

- :doc:`../scripts/index` (``init-tmux.sh``)
- :doc:`../shells/index` (``dev.sh``)

Notes
-----

- fastfetch configurations are experimental and may change frequently.
- tmux behavior is tightly integrated with the shell environment.