# fwm

X11 & wmutils enhancer scripts for cwm. Can be used independently. I use cwm
for sloppy focus, ewmh support, and groups.

Dependencies:

- [core](https://github.com/wmutils/core)
- [opt](https://github.com/wmutils/opt)
- [mmutils](https://github.com/pockata/mmutils)
- xprop

Optional:

- [cwm](https://tools.suckless.org/dmenu)
- [dmenu](https://tools.suckless.org/dmenu)
- [sxhkd](https://github.com/baskerville/sxhkd)

###### adjust

Adjusts position of window in a direction by the amount chosen in fwmrc.

###### closer

Focuses the closest window in a given direction. If no window is currently
focused, uses mouse x y coordinates to find closest window.

###### focus

Focus a window id, or cycle through the ordered stack of windows on screen.

###### full

Fullscreen a given window id. Run the same command to reset the window back to
its original position. Improved over cwm window-fullscreen by following mouse.

###### fwmrc

Sets various environment variables and can be sourced by your shell for usage
of it's custom xprop wrapper functions for retrieving window names, classes and
process ids.

###### move

Move and position windows on your multihead setup. Follows mouse pointer for
monitor information.

###### under

Prints the id of the window currently underneath the cursor. If no window is
found and has an argument passed to it, the given command will be executed.
Useful for running dmenu scripts based on selection of the root window. You'll
need to use the following example in your sxhkd if you want to bind to the
mouse:

```
~button3
    under wmenu
```

###### tile

Tile windows on a given screen in a variety of manners. Variety includes simple
vertical and horizontal splits, or a 'focused' mode similar to dwm style.

###### watcher

An window id event watcher wrapper around wew to provide added functionality.
Recommend to add `watcher &` to your xinitrc to load on X11 start.

###### wid

Find any visible window id whose name or class properties fuzzy match a given
string.

###### wmenu

dmenu selection menu for visible windows.
