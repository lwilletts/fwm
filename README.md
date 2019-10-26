# fwm

wmutils scripts to be used with a simple window manager that doesn't get in the
way.

Dependencies:

- [core](https://github.com/wmutils/core)
- [opt](https://github.com/wmutils/opt)
- [mmutils](https://github.com/pockata/mmutils)
- xorg-xprop

Known good WMs:
- [cwm](https://tools.suckless.org/dmenu)
- [glazier](https://git.z3bra.org/glazier/log.html)

Optional:
- [txtw](https://github.com/baskerville/txtw)
- [dmenu](https://tools.suckless.org/dmenu)
- [sxhkd](https://github.com/baskerville/sxhkd)
- [xrectsel](https://github.com/lolilolicon/xrectsel)

#### adjust

Adjusts position of window in a direction by the moveamount given in cwmrc.

#### closer

Focuses the closest window in a given direction. If no window is currently
focused, uses mouse x y coordinates to find closest window.

#### cmdmenu

Mouse centric workflow menu, create new terminals, move, resize and delete
windows and their processes. Control clipboard and load from clipboard.
Hardcoded font size for now.

#### focus

Focus a window id, or cycle through the ordered stack of windows on screen.

#### full

Fullscreen a given window id. Run the same command to reset the window back to
its original position. Improved over cwm window-fullscreen by following mouse.

#### fwmrc

Sets various environment variables and can be sourced by your shell for usage
of custom xprop wrapper functions for retrieving window names, classes and
process ids.

#### group

Basic group script for window mapping.

#### move

Move and position windows on your multihead setup. Follows mouse pointer for
monitor information if no monitor given.

#### under

Prints the id of the window currently underneath the cursor. If no window is
found and has an argument passed to it, the given command will be executed.
Useful for running dmenu scripts based on selection of the root window. You'll
need to use the following example in your sxhkd if you want to bind to the
mouse:

```
~button3
    under wmenu
```

#### tile

Tile windows on a given screen in a variety of manners. Still under
development.

#### watcher

An window id event watcher wrapper around wew to provide added functionality.
Recommend to add `watcher &` to your xinitrc to load on X11 start.

#### wid

Find any visible window id whose name or class properties fuzzy match a given
string.

#### wmenu

dmenu selection menu for visible windows. Functions either as a bar, floating
window based on mouse location, or a floating window placed in the center of
current screen.

#### patch

Small wmutils and other util patches I have collected.
