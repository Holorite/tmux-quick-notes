#!/usr/bin/env bash

# Check tmux version (3.2+ required for display-popup)
tmux -V | grep -q ' 3\.[2-9]\| [4-9]\.' || {
  tmux display-message "Error: tmux 3.2+ required for display-popup"
  exit 1
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

mkdir -p $(notes_dir)

if [ ! -f $STATE_FILE ]; then
    printf '%s\n' "$(default_associativity)" > "$STATE_FILE"
fi

for key in $(note_keys); do
    tmux bind-key -N "Open note" $key run-shell "$CURRENT_DIR/scripts/open_note.sh"
done

for key in $(note_root_keys); do
    tmux bind-key -N "Open note" $key run-shell "$CURRENT_DIR/scripts/open_note.sh"
done

for key in $(search_notes_keys); do
    tmux bind-key -N "Search all notes" $key run-shell "$CURRENT_DIR/scripts/search_notes.sh"
done
