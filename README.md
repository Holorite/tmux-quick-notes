# Tmux Quick Notes
A simple associative notes manager for Tmux.

# Installation

## Dependencies

- fzf
- Tmux 5.5a
- sed

## Install Via [TPM](https://github.com/tmux-plugins/tpm)

Add this to your `~/.tmux.conf`
```.tmux.conf
set -g @plugin 'Holorite/tmux-quick-notes'
```
Then reload your configuration and press `prefix` + `I`.

# Usage

Open a note with `prefix C-e`. A markdown note will be created using the current associativity and saved under `~/.local/share/tmux/tmux-quick-notes/`

`prefix e` opens the notes menu allowing:
(make table)
1. go to a notes associated location
2. open a note in this window
3. delete note(s)
4. switch current associativity
