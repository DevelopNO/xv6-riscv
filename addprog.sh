#!/bin/bash

# Script: addprog

# Enable tab completion for the script 'addprog'
_prog_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -f -- "$cur") )
}
complete -F _prog_completion addprog

# Check if a program name was provided
if [ -z "$1" ]; then
    echo "Usage: addprog <program_name.c>"
    exit 1
fi

# Get the program name, stripping any path and extension
PROG_NAME=$(basename "$1" .c)

# Directory containing user programs
USER_DIR="./user"

# Check if the C file exists in the user directory
if [ ! -f "$USER_DIR/$PROG_NAME.c" ]; then
    echo "Error: $USER_DIR/$PROG_NAME.c does not exist."
    exit 1
fi

# Prepare the program entry for UPROGS with a tab at the beginning
UPROG_ENTRY="$(printf '\t$U/_%s\\' "$PROG_NAME")"

# Path to the Makefile
MAKEFILE="./Makefile"

# Check if the program is already in UPROGS
if grep -qF "$UPROG_ENTRY" "$MAKEFILE"; then
    echo "Program $PROG_NAME is already in UPROGS."
else
    # Use awk to insert the line after UPROGS=
    awk -v new_line="$UPROG_ENTRY" '/^UPROGS=/ && !done { print; print new_line; done=1; next }1' "$MAKEFILE" > Makefile.new && mv Makefile.new "$MAKEFILE"
    echo "Added $PROG_NAME to UPROGS in the Makefile."
fi

