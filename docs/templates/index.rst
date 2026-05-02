Templates
=========

This section documents reusable templates and configuration files.

Overview
--------

The ``templates/`` directory acts as a central repository for:

- Project skeletons
- Document templates
- Formatter configurations

Templates are typically:

- Copied into new projects
- Used as a starting point for documents
- Referenced by external tools

Structure
---------

The directory is organized by type:

- ``latex/``: LaTeX document templates
- ``typst/``: Typst templates and projects
- ``misc/``: Miscellaneous configuration files

LaTeX
-----

Templates for LaTeX-based documents.

Available variants include:

- ``simple/``: minimal document structure
- ``uni/``: university-oriented template
- ``uni-group/``: group project variant

Each template typically contains:

- ``main.tex``: entry point
- Supporting files (e.g. ``def.tex``, ``.cls``)
- ``img/`` directory for assets

Example:

.. literalinclude:: ../../templates/latex/simple/main.tex
   :language: latex
   :linenos:

Typst
-----

Templates and projects for Typst.

General Structure
~~~~~~~~~~~~~~~~~

- ``main.example.typ``: example entry point
- ``justfile``: build automation
- ``note.md``: notes or usage documentation

UNDAV Template
~~~~~~~~~~~~~~

Located at:

- ``templates/typst/undav``

This template is handled differently from the others.

Instead of being copied into projects, it is symlinked into Typst's
global template directory.

Example:

.. code-block:: text

   ~/.local/share/typst/packages/local/undav/1.0.0
     -> /path/to/repo/templates/typst/undav

This allows it to be imported directly in Typst documents without copying.

Advantages:

- Centralized updates
- No duplication across projects
- Cleaner project structure

Misc
----

Miscellaneous reusable configuration files.

Includes:

- ``dotnet_editorconfig``: editor configuration for .NET projects
- ``.php-cs-fixer.dist.php``: PHP formatting rules

These files are typically copied into project roots when needed.

Notes
-----

- Templates are intentionally minimal and meant to be adapted per project.
- Some templates depend on external tools (e.g. LaTeX, Typst).
- The Typst UNDAV template uses a symlink-based workflow for reuse.