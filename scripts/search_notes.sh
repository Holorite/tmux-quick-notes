#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

if [[ -z "$1" ]]; then
    action=$(printf "goto\nopen\ndelete\nswitch associativity\n[cancel]" | fzf --tmux --header='Select an action.')
else
    action="$1"
fi
[[ "$action" == "[cancel]" || -z "$action" ]] && exit

nd=$(notes_dir)

out=""
for n in $(ls $nd | grep $(note_file_type)); do
    out+="$(head -n 1 $nd/$n) ($n)\n"
done
out+="[cancel]\n"

if [[ $action == "delete" ]]; then
    args="-m"
    header="Delete notes (press TAB)"
elif [[ $action == "open" ]]; then
    header="Open a note (in this window)"
elif [[ $action == "goto" ]]; then
    header="Open a note (in its associated location)"
elif [[ $action == "switch associativity" ]]; then
    associativity=$(printf "window\nsession\nglobal\n[cancel]" | fzf --tmux --header='Select an associativity.')
    [[ "$associativity" == "[cancel]" || -z "$associativity" ]] && exit
    printf '%s\n' "$associativity" > "$STATE_FILE"
    exit
fi

mapfile -t target_map < <(printf "$out" | fzf --tmux $args --header="$header" --preview="$CURRENT_DIR/.preview_note {} $nd")
[[ ${#target_map[@]} -eq 0 ]] && exit

# Extract filenames
targets=()
for t in "${target_map[@]}"; do
    [[ "$t" == "[cancel]" ]] && exit
    targets+=($(echo $t | sed 's/.* (\(.*\))/\1/g'))
done

if [[ $action == "delete" ]]; then
    printf "%s\n" "${targets[@]}" | xargs -I{} rm "$nd/{}"
    exit
fi

$CURRENT_DIR/open_note.sh --name ${targets[0]} --mode $action
