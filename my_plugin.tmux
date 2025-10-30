#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key C-n run-shell "$CURRENT_DIR/scripts/tmux_show_notes.sh"
