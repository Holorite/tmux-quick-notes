#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

note_name=$(tmux display-message -pF "$(note_name_format)")
note_cmd="$(note_editor) $(note_path $note_name)"

pane_id_format="#S:#I.#P"
current_pane=$(tmux display-message -pF "$pane_id_format")

panes=$(tmux list-panes -a -F "$pane_id_format" -f "#{m:$note_cmd,#{pane_start_command}}")
pane=${panes[0]}

# Behaviour:
# - If a pane open with the note does not exist then make one
# Otherwise either switch to it or close it if it is the current pant
if [ -z $pane ]; then
    tmux split-window $(note_split_options) $note_cmd
else
    if [[ $pane == $current_pane ]]; then
        tmux send-keys -t $pane $(note_exit_keys)
    else
        tmux switch-client -t $pane
        tmux select-window -t $pane
        tmux select-pane -t $pane
    fi
fi
