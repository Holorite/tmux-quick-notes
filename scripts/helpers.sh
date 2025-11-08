if [ -d "$HOME/.tmux/quick-notes" ]; then
    default_notes_dir="$HOME/.tmux/quick-notes"
else
    default_notes_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/tmux/quick-notes
fi

_NOTES_DIR=""

get_tmux_option() {
    local key="$1" default="$2"
    local value=$(tmux show-options -gqv "$key")
    echo "${value:-$default}"
}

# Keybindings
note_keys() { get_tmux_option @quick-notes-keys "C-e" ; }
note_root_keys() { get_tmux_option @quick-notes-root-keys "" ; }

associative_note_keys() { get_tmux_option @associative-notes-keys "E" ; }

search_notes_keys() { get_tmux_option @quick-notes-search-notes-keys "e" ; }

# Associativity and files
note_file_type() { get_tmux_option @quick-notes-file-type ".md" ; }
default_associativity() { get_tmux_option @quick-notes-default-associativity "session" ; }
window_format() { get_tmux_option @quick-notes-window-format "#S:#I" ; }
session_format() { get_tmux_option @quick-notes-session-format "#S" ; }
global_format() { get_tmux_option @quick-notes-global-format "global_notes" ; }

get_default_format() {
    echo $(get_format $(default_associativity))
}
get_format() {
    val=$(eval "$1_format")
    if [[ -z "$val" ]]; then
        echo "Unknown format name: $1"
        exit 1
    fi
    echo "$val$(note_file_type)"
}

# Editor options
note_editor() { get_tmux_option @quick-notes-editor "nvim" ; }
note_exit_keys() { get_tmux_option @quick-notes-split-options "Escape :silent! q Enter :wq Enter" ; }

# Visual options
note_popup_options() { get_tmux_option @quick-notes-popup-options "-x C -w 35%" ; }
note_split_options() { get_tmux_option @quick-notes-split-options "-h -l 30%" ; }

# directories
notes_dir() {
	if [ -z "$_NOTES_DIR" ]; then
		local path="$(get_tmux_option @quick-notes-dir "$default_notes_dir")"
		# expands tilde, $HOME and $HOSTNAME if used in @quick-notes-dir
		echo "$path" | sed "s,\$HOME,$HOME,g; s,\$HOSTNAME,$(hostname),g; s,\~,$HOME,g"
	else
		echo "$_NOTES_DIR"
	fi
}
_NOTES_DIR="$(notes_dir)"

note_path() {
    local note_name="$1"
    echo "$(notes_dir)/$1"
}

STATE_FILE=$(note_path "state.txt")
