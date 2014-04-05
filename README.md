# vim-dentures

Indentation text-objects to give your old Vim some new byte.

## Introduction

In addition to helping old people chew food, "dentures" is a playful term I 
made up for indentation *text-objects*, and is also the name of this plugin.

## Text Objects

Dentures introduces the following *text-objects* to your crusty old Vim, all
of which are available in *visual-mode* and *Operator-pending-mode*:

* `ai`: "an indent", select surrounding lines with greater or equal
  indentation, delimited by blank lines. Leading or trailing blank lines are
  included in the selection.

* `ii`: "inner indent", select surrounding lines with greater or equal
  indentation, delimited by blank lines.

* `aI`: "an INDENT", select surrounding lines with greater or equal
  indentation, including blank lines between and leading or trailing blank
  lines.

* `iI`: "inner INDENT", select surrounding lines with greater or equal
  indentation, including blank lines between.

When any of the above *text-objects* are invoked from *blockwise-visual* mode,
the selection will begin at the first non-blank character of the first
selected line. Try it; you'll like it. (See `:help blockwise-operators`)

## Take A Bite

The best way to wrap your head around dentures is to take a bite; try out each
of the *text-objects* introduced by this plugin for yourself. Great care has
been taken to behave in a way that is consistent with other *text-objects*.
