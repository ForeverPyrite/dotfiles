
# Considerations

## Clipboard manager
PLEASE :sob:

## Atuin
Is this really worth the extra features or should I just use Ctrl+R with fzf?

## WezTerm
Alacritty is putting in the work, and it's exactly what I wanted.
However, as I'm living inside of the terminal, I'm considering taking
advantage of TUIs that utilize features that TEs like kitty and WezTerm
provide.

Most of the futures a terminal like WezTerm has built in are easily
replaced by tmux and it's plugins, I feel

## Tmux

### A proper system

I still need to figure things out with stuff like tmux-ressurect, curating a good way for me to manage my workflows

### The infinite plugin grind.
Of course, this never stops.

The only thing I want want is a way to manage sessions within tmux, as explained below.

tmux-browser seems cool and useful for productivity, since the web browser is where I end up getting distracted the most 
(it's why I'm here instead of finishing up Arch Linux stuff)

### `exec`ing off to `tmux` on `conifg.fish`

As it stands, when I enter a login shell, fish enters the "home" session
This is weird though.

1. It attaches to the same session, which means it shares the active window.
This means that if I open another terminal, it will attach to the home session.

This is good in the sense it is requiring me to be more thoughtful of creating new
windows, instead of having 15 unnamed alacritty windows.
However, it's very unexpected and confusing

### On-startup processes

Would be good for the above, have each session have a window and some panes
when the system starts for services.
These would be different than the tmux continum restorations.

An example would be like a "syncthing" session with a window running the
`syncthing` command.
This example is poor since it'd be more effective to run a system service,
but the point remains.

There is surely some plugin or utility to help programmatically create sessions
within tmux, after all


# Things to do

## Customize prompt

### Starship
 - Change colors
 - Find better Git Status Symbols

### Fish
 - Typed things (since these aren't overwritten by Starship)
