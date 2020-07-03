# fwm

![chromebook setup](https://i.redd.it/qfglwtdlwuh41.png)

[wmutils](https://blog.z3bra.org/2015/01/you-are-the-wm.html) scripts to be
used by themselves to provide a full environment or alongside a sane window
manager that has minimal or no EWMH support.

Dependencies:
- [core](https://github.com/wmutils/core)
- [opt](https://github.com/wmutils/opt)
- [mmutils](https://github.com/pockata/mmutils)

Known good WMs:
- [cwm](hhttps://github.com/leahneukirchen/cwm)
- [glazier](https://git.z3bra.org/glazier/log.html)

Optional:
- [txtw](https://github.com/baskerville/txtw): for calculating menu width
- [sxhkd](https://github.com/baskerville/sxhkd): binding of hotkeys
- [dmenu](https://tools.suckless.org/dmenu): for menu selections
- [xrectsel](https://github.com/lolilolicon/xrectsel): mouse placement of new
  windows

#### adjust

Adjusts position of window in a direction by the `$JUMP` amount set in `fwmrc`.

#### autotile

Quick and dirty script to autotile a monitor using a particular tile method.

#### closer

Focuses the closest window in a given direction. If no window is currently
focused, mouse x y coordinates are used to find the closest window.

#### cmdmenu

Mouse centric workflow menu. Create new terminals, move, resize and delete
windows and their processes. Control clipboard and load from clipboard.
Hardcoded font size for now.

#### drun

Open programs using dmenu either as a bar or as a floating window placed in the
center of current screen. Uses my zsh config to pull full `$PATH` for program
selection.

#### envreact

Dynamic program launching / stopping based on other programs. Reads
`$HOME/.autoreact`. Add `envreact &` to your xinitrc to load on X11 start.

Example configuration file:

```
cwm_run MidairCE
snip_run obs
picom_end MidairCE Tribes.exe DOOM ShadowOfTheTombRaider
```

#### focus

Focus a window id, or cycle through the ordered stack of windows on screen.

#### fwmrc

Sets various environment variables like colours, gaps, borderwidth etc.

#### group

CWM-like group script to hide and show windows.

#### invert

Invert window stacking order for windows matching the given search string. See
`wid`.

#### move

Move and position windows on a multihead setup. Follows mouse pointer for
monitor information if no monitor is given.

#### sshmenu

dmenu populated list of hostnames to connect to. Defaults to using mosh, with
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

Tile windows on a given screen in a variety of manners. Tiling logic still under
development.

#### watcher

A window id event watcher wrapper around wew to provide added functionality:

- sloppy focus
- window placement
- autogrouping of windows

Modify to meet your needs.

Add `watcher &` to your xinitrc to load on X11 start.

Autogrouping is possible by populating `$HOME/.autogroup` with `WM_CLASS` and a
group:

```
2 qutebrowser
3 discord
4 gl
```

#### wid

Find any visible window id whose `WM_NAME` or `WM_CLASS` properties that fuzzy
match a given string.

#### wmenu

dmenu selection menu for visible windows. Functions either as a bar, floating
window based on mouse location, or as a floating window placed in the center of
current screen.

## src

Directory for small C programs, patches and example config files.

#### sxhkd.example

My personal sxhkd configuration to provide a full wmutils environment on it's
own.

#### xinitrc.example

My personal xinitrc configuration to launch everything I need on X11 start.

#### xwait

Infinite loop, used to hold X connection open.

#### patch

Small wmutils and other util patches I have collected.
