# fwm

A set of wmutils/mmutils/xprop scripts to extend cwm with better multihead and
keyboard support, and

### fwmrc

The main environment file that sources various information like cwm variables
and also includes functions to list 

### wid

Find any visible window id whose name or class properties fuzzy match a given
string.

### focus

Focus a window id, or focus through the ordered stack of windows on screen.

TODO: cycle through windows on a given screen

### closer

Focuses the closest window in a given direction.

### full

Fullscreen a given window id. Run the same command to reset the window back to
its original position. Used mainly so windows can be fullscreened by a script
and then unfullscreened by the user.

### event

An window id event watcher wrapper around wew to provide added functionality
such as automatically adding windows to groups via `open` or providing cleanup
when a window is closed. Recommend to add `event` to your xinitrc to load on X11
start.

### group

My own groups script to add various options over default cwm maps. Functionally
very similar to how you can use cwm groups, but I have found cwm groups to have
issues with wine windows.

### open

When a window class matches the given window id, run commands. These can be
adding windows to a certain group or position. Edit based on your own personal
preference, examples are given.

### close

Script to specifically target EMWH-compliant programs via the kill
command to properly terminate the process behind the window.

### move

Move and position windows on your multihead setup.
