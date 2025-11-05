#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

SEARCH_FZF="$CURRENT_DIR/fzf_menu.sh"

nd=$(notes_dir)

out=""
for n in $(ls $nd); do
    out+="$(head -n 1 $nd/$n) ($n)\n"
done
out+="[cancel]\n"

target=$(printf "$out" | fzf --tmux --preview="$CURRENT_DIR/.preview_note {} $nd")
[[ "$target" == "[cancel]" || -z "$target" ]] && exit

# Extract filename 
target=$(echo $target | sed 's/.* (\(.*\))/\1/')

$CURRENT_DIR/open_note.sh $target

