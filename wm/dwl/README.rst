dwl configuration
=================

Overview
--------

This repository contains configuration, patches, and customizations for
``dwl`` and related tools.

Patches
-------

Core (dwl)
~~~~~~~~~~

``foreign-toplevel-management.patch``
   Enables the foreign toplevel management protocol so tools like
   ``lswt`` can query open windows and their ``app_id``.

   .. note::

      This patch requires a manual Makefile fix. Refer to the patch
      comments for details.

``switchlayout.patch``
   Adds ``switchlayout(const Arg *arg)`` for programmatic switching of
   XKB keyboard layout groups.

   The current layout name is written to ``/tmp/dwl-layout`` for
   consumption by status bars.

``floating-window-pos.patch``
   Extends the ``Rule`` struct with ``x`` and ``y`` fields, allowing
   control over the spawn position of floating windows.

Status bar (dwlb)
~~~~~~~~~~~~~~~~~

``no-flicker.patch``
   Redraws the status bar only when content changes, eliminating flicker
   caused by frequent updates.

Keyboard (XKB)
--------------

Custom symbols
~~~~~~~~~~~~~~

Custom symbols are defined in:

- ``xkb/custom`` (symlinked to
  ``/usr/share/X11/xkb/symbols/custom``)

Configuration
~~~~~~~~~~~~~

The following line must be added to:

``/usr/share/X11/xkb/rules/evdev``

Inside the ``! option = symbols`` section (around line 726):

::

   custom:nodead_circumflex_grave = +custom(nodead_circumflex_grave)

.. important::

   This step is required for the custom layout option to be recognized
   by XKB.

Behavior
~~~~~~~~

- ``AltGr+{`` produces ``^`` (no dead key)
- ``AltGr+}`` produces a backtick
- The Spanish ``tilde`` remains a dead key

.. tip::

   This setup preserves standard Spanish input while improving access to
   commonly used symbols in programming.

Implementation Notes
--------------------

- ``config.h`` and ``dwl.desktop`` are managed as symlinks
- XWayland support is enabled in ``config.mk``

.. warning::

   Misconfigured symlinks may cause unexpected behavior during rebuilds
   or updates.

Repository Metadata
-------------------

- ``VERSIONS`` tracks tools and their exact versions
- ``PATCHES`` lists applied patches