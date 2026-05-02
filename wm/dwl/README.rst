dwl configuration
=================

Overview
--------

This section contains configuration, patches, and customizations for
``dwl`` and related tools.

Patches
-------

Core patches
~~~~~~~~~~~~

The following patches are applied to ``dwl``:

``foreign-toplevel-management.patch``
   Enables the foreign toplevel management protocol so tools like
   ``lswt`` can query open windows and their ``app_id``.

   Note:
      Requires a manual Makefile fix (see patch comments).

``switchlayout.patch``
   Adds ``switchlayout(const Arg *arg)`` for switching XKB keyboard
   layout groups programmatically.

   Also writes the current layout name to ``/tmp/dwl-layout`` for use
   in status bars.

``floating-window-pos.patch``
   Extends the ``Rule`` struct with ``x`` and ``y`` fields, allowing
   control over the spawn position of floating windows.

Status bar (dwlb)
~~~~~~~~~~~~~~~~~

The following patch is applied to ``dwlb``:

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

To enable the layout option, add the following line to:

``/usr/share/X11/xkb/rules/evdev``

Inside the ``! option = symbols`` section (around line 726):

::

   custom:nodead_circumflex_grave = +custom(nodead_circumflex_grave)

Behavior
~~~~~~~~

- ``AltGr+{`` produces ``^`` (no dead key)
- ``AltGr+}`` produces a backtick (`` ` ``)
- The Spanish ``tilde`` remains a dead key

Implementation Notes
--------------------

- ``config.h`` and ``dwl.desktop`` are managed as symlinks
- XWayland support is enabled in ``config.mk``

Repository Metadata
-------------------

- ``VERSIONS`` tracks tools and their exact versions
- ``PATCHES`` lists applied patches