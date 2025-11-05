#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

if [[ -z "$1" ]]; then
    action=$(printf "open\ndelete\n[cancel]" | fzf --tmux --header='Select an action.')
else
    action="$1"
fi
[[ "$action" == "[cancel]" || -z "$action" ]] && exit

nd=$(notes_dir)

out=""
for n in $(ls $nd); do
    out+="$(head -n 1 $nd/$n) ($n)\n"
done
out+="[cancel]\n"

header="Open a note"
if [[ $action == "delete" ]]; then
    args="-m"
    header="Delete notes (press TAB)"
fi

mapfile -t target < <(printf "$out" | fzf --tmux $args --header="$header" --preview="$CURRENT_DIR/.preview_note {} $nd")

# Extract filenames
target_str=""
for t in "${target[@]}"; do
    [[ "$t" == "[cancel]" ]] && exit
    target_str+="$(echo $t | sed 's/.* (\(.*\))/\1/g')\n"
done
[[ -z "$target_str" ]] && exit

if [[ $action == "delete" ]]; then
    echo -e $target_str | xargs -I{} rm "$nd/{}"
    exit
fi

$CURRENT_DIR/open_note.sh $target_str

