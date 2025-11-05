#!/usr/bin/env bash

fail() {
  exit 2
}

fzf="$(command which fzf)"
[[ -x "$fzf" ]] || fail 'fzf not found'

# Parse options
wd=$1
shift
argf="$@"
echo "$*"
exit 2

# Temporary files and fifos
id=$RANDOM
fifo_in="/tmp/quick-notes-fifo-in-$id"
fifo_out="/tmp/quick-notes-fifo-out-$id"
mkfifo $fifo_in
mkfifo $fifo_out

clean() {
    rm $fifo_in
    rm $fifo_out
}

# Run fzf
cat $fifo_out &
tmux display-popup -w 62% -d $wd -E "bash -c 'fzf \"$argf\" < $fifo_in > $fifo_out'" &
cat - > "$fifo_in"

clean
