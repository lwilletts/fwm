# fwm

wmutils scripts to be used by themselves or with a simple window manager that
doesn't get in the way.

Dependencies:
- [core](https://github.com/wmutils/core)
- [opt](https://github.com/wmutils/opt)
- [mmutils](https://github.com/pockata/mmutils)

Known good WMs:
- [cwm](https://tools.suckless.org/dmenu)
- [glazier](https://git.z3bra.org/glazier/log.html)

Optional:
- [txtw](https://github.com/baskerville/txtw)
- [dmenu](https://tools.suckless.org/dmenu)
- [sxhkd](https://github.com/baskerville/sxhkd)
- [xrectsel](https://github.com/lolilolicon/xrectsel)

#### adjust

Adjusts position of window in a direction by the $JUMP amount set in `fwmrc`.

#### closer

Focuses the closest window in a given direction. If no window is currently
focused, uses mouse x y coordinates to find closest window.

#### cmdmenu

Mouse centric workflow menu. Create new terminals, move, resize and delete
windows and their processes. Control clipboard and load from clipboard.
Hardcoded font size for now.

#### envreact

Dynamic program launching / stopping based on other programs. Example config:

```
MidairCE picom_end
obs cwm_run snip_run
```

#### focus

Focus a window id, or cycle through the ordered stack of windows on screen.

#### fwmrc

Sets various environment variables like colours, gaps, borderwidth etc.

#### group

Group script to hide and show windows.

#### move

Move and position windows on a multihead setup. Follows mouse pointer for
monitor information if no monitor given.

#### sshmenu

Dmenu populated list of hostnames to connect to. Defaults to using mosh, with
ssh as backup.

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

A window id event watcher wrapper around wew to provide added functionality:

- sloppy focus
- window placement
- autogrouping of windows

Add `watcher &` to your xinitrc to load on X11 start.

Autogrouping is possible by populating `$HOME/.autogroup` with WM_CLASS and a
group:

```
2 qutebrowser
3 discord
4 gl
```

#### wid

Find any visible window id whose WM_NAME or WM_CLASS properties fuzzy match a
given string.

#### wmenu

dmenu selection menu for visible windows. Functions either as a bar, floating
window based on mouse location, or a floating window placed in the center of
current screen.

## src

A directory for small C programs and testing of ideas.

#### xwait

Infinite loop, used to hold X connection open.

#### patch

Small wmutils and other util patches I have collected.
