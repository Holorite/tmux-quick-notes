# Tmux Quick Notes

A simple associative notes manager for Tmux. 
Open and search for window, session, or globally associated notes.

# Installation

## Dependencies

- [fzf](https://github.com/junegunn/fzf)
- [Tmux 3.3a](https://github.com/tmux/tmux/wiki)
- sed

## Install Via [TPM](https://github.com/tmux-plugins/tpm)

Add this to your `~/.tmux.conf`
```.tmux.conf
set -g @plugin 'Holorite/tmux-quick-notes'
```
Then press `prefix` + `I` to install.

# Usage

Open a note with `prefix` + `C-e`. A markdown note will be created using the current associativity and saved under `~/.local/share/tmux/tmux-quick-notes/`


## `prefix` + `e` notes menu:


| Mode | Description |
| -------------- | --------------- |
| goto | Open a note in its associated location |
| open | Open a note in this window |
| delete | Select note(s) to delete |
| switch associativity | Change the associativity used for `prefix` + `C-e` |

