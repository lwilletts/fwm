# fwm

Scripts to extend cwm with better multihead and keyboard support.

Dependencies:

- wmutils core
- wmutils opt
- mmutils
- xprop

###### closer

Focuses the closest window in a given direction. If no window is currently
focused, uses mouse x y coordinates to find closest window.

###### focus

Focus a window id, or focus through the ordered stack of windows on screen.

TODO: cycle through windows on a given screen

###### full

Fullscreen a given window id. Run the same command to reset the window back to
its original position. Improved over cwm window-fullscreen by following mouse.

###### fwmrc

A script that sources various environment variables from ~/.cwmrc and
implements global functions that can be called from the shell once sourced.

###### eventually

An window id event watcher wrapper around wew to provide added functionality.
Mainly cleaning up fullscreen window ids at the moment.  Recommend to add
`eventually &` to your xinitrc to load on X11 start.

###### move

Move and position windows on your multihead setup. Follows mouse pointer for
monitor information.

###### tile

Tile windows on a given screen horizontally or vertically.

TODO: not implemented yet

###### wid

Find any visible window id whose name or class properties fuzzy match a given
string.

###### extras

- group: groups implemented using `mapw` that does work but is not compatible
with cwm.
