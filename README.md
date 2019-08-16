# fwm

X11 & wmutils scripts

- [core](https://github.com/wmutils/core)
- [opt](https://github.com/wmutils/opt)
- [mmutils](https://github.com/pockata/mmutils)
- xprop

Options:

- [dmenu](https://tools.suckless.org/dmenu)
- [sxhkd](https://github.com/baskerville/sxhkd)

###### adjust

Adjusts position of window in a direction by the amount chosen in fwmrc.

###### closer

Focuses the closest window in a given direction. If no window is currently
focused, uses mouse x y coordinates to find closest window.

###### eventually

An window id event watcher wrapper around wew to provide added functionality.
Mainly cleaning up fullscreen window ids at the moment.  Recommend to add
`eventually &` to your xinitrc to load on X11 start.

###### focus

Focus a window id, or cycle through the ordered stack of windows on screen.
Accepts piped window id to focus.

###### full

Fullscreen a given window id. Run the same command to reset the window back to
its original position. Improved over cwm window-fullscreen by following mouse.

###### fwmrc

A script that sources various environment variables from ~/.cwmrc and
implements global functions that can be called from the shell once sourced.

###### group

Groups implemented using `mapw` that does work but is not compatible
with cwm as it maps all new visible windows to mouse pointer location.

###### move

Move and position windows on your multihead setup. Follows mouse pointer for
monitor information.

###### under

Detects if the window underneath the mouse pointer is the root window. If it
is, the given command will be run. Useful a window selection menu CWM style.
You'll need to use the following example in your sxhkd if you want to bind to
the mouse.

```
~button3
    under wmenu
```

###### tile

Tile windows on a given screen horizontally or vertically.

TODO: not implemented yet

###### wid

Find any visible window id whose name or class properties fuzzy match a given
string.

###### wmenu

dmenu selection menu for visible windows.
