#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "error"
	exit 1
fi

base="$(dirname $1)/$(basename $1 .c)"
exec_name="$(dirname $1)/_$(basename $1 .c)"

if [ ! -f $base.c ] && [ ! -f $base.o ] && [ ! -f $base.d ] && [ ! -f $base.asm ] && [ ! -f $base.sym ] && [ ! -f $exec_name ]; then
	echo "file wasn't found."
	exit 1
fi

rm "$base.c" || true
rm "$base.d" || true
rm "$base.asm" || true
rm "$base.sym" || true
rm "$base.o" || true
rm "$exec_name" || true

# Get the program name, stripping any path and extension
PROG_NAME=$(basename "$1" .c)

# Prepare the program entry pattern to remove
UPROG_ENTRY=$(printf '\t$U/_%s\\' "$PROG_NAME")

# Path to the Makefile
MAKEFILE="./Makefile"

# Check if the program is in UPROGS
if grep -qF "$UPROG_ENTRY" "$MAKEFILE"; then
    # Remove the line from the Makefile
    awk -v remove_line="$UPROG_ENTRY" '$0 != remove_line { print }' "$MAKEFILE" > Makefile.new && mv Makefile.new "$MAKEFILE"
    echo "Removed $PROG_NAME from UPROGS in the Makefile."
else
    echo "Program $PROG_NAME is not in UPROGS."
fi
