#!/bin/bash
# grepai auto-start hook for Claude Code
# Automatically starts grepai watch when entering a project with .grepai/

GREPAI_BIN="$HOME/.local/bin/grepai"
PROJECT_DIR="$(pwd)"
LOCK_FILE="/tmp/grepai-session-$(echo "$PROJECT_DIR" | md5 | cut -c1-8).lock"

# Exit silently if grepai not installed
[[ ! -x "$GREPAI_BIN" ]] && exit 0

# Exit if project not initialized
[[ ! -d "$PROJECT_DIR/.grepai" ]] && exit 0

# Check if we already ran this session (lock file less than 1 hour old)
if [[ -f "$LOCK_FILE" ]]; then
    LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$LOCK_FILE" 2>/dev/null || echo 0) ))
    [[ $LOCK_AGE -lt 3600 ]] && exit 0
fi

# Try to start watch (silently fails if already running)
"$GREPAI_BIN" watch --background >/dev/null 2>&1

# Create/update lock file
touch "$LOCK_FILE"

exit 0
