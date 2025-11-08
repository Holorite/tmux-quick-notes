#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

get_note_cmd() {
    echo "$(note_editor) $(note_path $TARGET_NOTE_NAME)"
}

if [ -f "$STATE_FILE" ]; then
    read -r associativity < "$STATE_FILE"
else
    associativity = $(default_associativity)
fi

FORMAT=$(get_format "$associativity")
TARGET_NOTE_NAME=$(tmux display-message -pF "$FORMAT")
MODE="goto"
while true; do
    case "$1" in
        --name ) TARGET_NOTE_NAME="$2"; shift 2;;
        --associativity ) FORMAT=$(get_format "$2"); TARGET_NOTE_NAME=$(tmux display-message -pF "$FORMAT"); shift 2;;
        --mode ) MODE="$2"; shift 2;;
        -- ) shift; break ;;
        * ) break ;;
    esac
done

note_cmd=$(get_note_cmd $TARGET_NOTE_NAME)

target_pane=${TARGET_NOTE_NAME%.md}

pane_id_format="#S:#I.#P"
current_pane=$(tmux display-message -pF "$pane_id_format")
existing_panes=$(tmux list-panes -a -F "$pane_id_format" -f "#{m:$note_cmd,#{pane_start_command}}")
found_pane=${existing_panes[0]}

# Behaviour:
# - If a pane open with the note does not exist then make one
# Otherwise either switch to it or close it if it is the current pant
if [[ -z $found_pane ]]; then

    if [[ $MODE == 'goto' ]]; then
        if [[ $FORMAT != $(get_format 'global') ]]; then
            tmux switch-client -t "$target_pane"
        fi
        # If we were not able to go to the pane specified in the note name then the note has been orphaned
        status=$?
        if [ $status -ne 0 ]; then 
            header="This note is orphaned"
            if [ -s $(note_path $target_note_name) ]; then 
                header+=", cannot rebind as $target_note_name exists."
            else
                actions="rebind\n"
                header+=", rebind to $target_note_name?"
            fi
            actions+="open\ndelete\n[cancel]\n" 

            action=$(printf "$actions" | fzf --tmux --footer="Orphaned note: $note_name" --header="$header")
            [[ "$action" == "[cancel]" || -z "$action" ]] && exit

            if [[ "$action" == 'delete' ]]; then
                rm $(note_path $note_name)
                exit
            elif [[ "$action" == 'rebind' ]]; then
                mv $(note_path $note_name) $(note_path $target_note_name)
                get_note_cmd $target_note_name
            fi
        fi
    elif [[ $MODE == 'open' ]]; then
        :
    else
        echo "Unknown opening mode: $MODE"
        exit 2
    fi

    tmux split-window $(note_split_options) $note_cmd

else # Note is already open somewhere
    # Close it if we are already in that pane
    if [[ $found_pane == $current_pane ]]; then
        tmux send-keys -t $found_pane $(note_exit_keys)
        sleep 0.1 # sleep to ensure file gets saved first

        # Automatically remove the note if it is empty
        if [ ! -s $(note_path $note_name) ]; then
            rm $(note_path $note_name)
        fi
    else
        tmux switch-client -t $found_pane
    fi
fi
