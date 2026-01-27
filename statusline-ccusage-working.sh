#!/bin/bash

# Add bun to PATH if not already there
export PATH="$HOME/.bun/bin:$PATH"

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
GRAY='\033[0;90m'
LIGHT_GRAY='\033[0;37m'
RESET='\033[0m'

# Read JSON input from stdin
input=$(cat)

# Extract current session ID and model info from Claude Code input
session_id=$(echo "$input" | jq -r '.session_id // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')


# Get current git branch with error handling
if git rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    if [ -z "$branch" ]; then
        branch="detached"
    fi
    
    # Check for pending changes (staged or unstaged)
    if ! git diff-index --quiet HEAD -- 2>/dev/null || ! git diff-index --quiet --cached HEAD -- 2>/dev/null; then
        # Get line changes for unstaged and staged changes
        unstaged_stats=$(git diff --numstat 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added+0, deleted+0}')
        staged_stats=$(git diff --cached --numstat 2>/dev/null | awk '{added+=$1; deleted+=$2} END {print added+0, deleted+0}')
        
        # Parse the stats
        unstaged_added=$(echo $unstaged_stats | cut -d' ' -f1)
        unstaged_deleted=$(echo $unstaged_stats | cut -d' ' -f2)
        staged_added=$(echo $staged_stats | cut -d' ' -f1)
        staged_deleted=$(echo $staged_stats | cut -d' ' -f2)
        
        # Total changes
        total_added=$((unstaged_added + staged_added))
        total_deleted=$((unstaged_deleted + staged_deleted))
        
        # Build the branch display with changes (with colors)
        changes=""
        if [ $total_added -gt 0 ]; then
            changes="${GREEN}+$total_added${RESET}"
        fi
        if [ $total_deleted -gt 0 ]; then
            if [ -n "$changes" ]; then
                changes="$changes ${RED}-$total_deleted${RESET}"
            else
                changes="${RED}-$total_deleted${RESET}"
            fi
        fi
        
        if [ -n "$changes" ]; then
            branch="$branch${PURPLE}*${RESET} ($changes)"
        else
            branch="$branch${PURPLE}*${RESET}"
        fi
    fi
else
    branch="no-git"
fi

# Get basename of current directory
dir_name=$(basename "$current_dir")

# Get today's date in YYYYMMDD format
today=$(date +%Y%m%d)

# Function to format numbers - Force locale to C for decimal points
format_cost() {
    # Use awk with forced C locale for reliable decimal formatting
    echo "$1" | LC_ALL=C awk '{printf "%.2f", $1}'
}

format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000000 ]; then
        echo "$tokens" | LC_ALL=C awk '{printf "%.1fM", $1/1000000}'
    elif [ "$tokens" -ge 1000 ]; then
        echo "$tokens" | LC_ALL=C awk '{printf "%.1fK", $1/1000}'
    else
        printf "%d" "$tokens"
    fi
}

format_time() {
    local minutes=$1
    local hours=$((minutes / 60))
    local mins=$((minutes % 60))
    if [ "$hours" -gt 0 ]; then
        printf "%dh %dm" "$hours" "$mins"
    else
        printf "%dm" "$mins"
    fi
}

# Initialize variables with defaults
session_cost="0.00"
session_tokens=0
daily_cost="0.00"
block_cost="0.00"
remaining_time="N/A"

# Determine which ccusage command to use
CCUSAGE_CMD=""
if command -v bunx >/dev/null 2>&1; then
    CCUSAGE_CMD="bunx ccusage"
elif command -v ccusage >/dev/null 2>&1; then
    CCUSAGE_CMD="ccusage"
fi

# Get current session data using ccusage session --id
if [ -n "$CCUSAGE_CMD" ] && [ -n "$session_id" ] && [ "$session_id" != "empty" ]; then
    # Use the new ccusage session --id functionality to get session data
    session_data=$($CCUSAGE_CMD session --id "$session_id" --json 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$session_data" ] && [ "$session_data" != "null" ]; then
        # Extract cost and tokens from the JSON response
        session_cost=$(echo "$session_data" | jq -r '.totalCost // 0')
        # Calculate only input + output tokens (exclude cache tokens for meaningful display)
        session_tokens=$(echo "$session_data" | jq -r '.entries | map(.inputTokens + .outputTokens) | add // 0')
    fi
fi

if [ -n "$CCUSAGE_CMD" ]; then
    # Get daily data
    daily_data=$($CCUSAGE_CMD daily --json --since "$today" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$daily_data" ]; then
        daily_cost=$(echo "$daily_data" | jq -r '.totals.totalCost // 0')
    fi
    
    # Get active block data
    block_data=$($CCUSAGE_CMD blocks --active --json 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$block_data" ]; then
        active_block=$(echo "$block_data" | jq -r '.blocks[] | select(.isActive == true) // empty')
        if [ -n "$active_block" ] && [ "$active_block" != "null" ]; then
            block_cost=$(echo "$active_block" | jq -r '.costUSD // 0')
            remaining_minutes=$(echo "$active_block" | jq -r '.projection.remainingMinutes // 0')
            if [ "$remaining_minutes" != "0" ] && [ "$remaining_minutes" != "null" ]; then
                remaining_time=$(format_time "$remaining_minutes")
            fi
        fi
    fi
fi

# Format the output
formatted_session_cost=$(format_cost "$session_cost")
formatted_daily_cost=$(format_cost "$daily_cost")
formatted_block_cost=$(format_cost "$block_cost")
formatted_tokens=$(format_tokens "$session_tokens")

# Build the first line: basic info
first_line="${LIGHT_GRAY}🌿 $branch ${GRAY}|${LIGHT_GRAY} 💄 $output_style ${GRAY}|${LIGHT_GRAY} 📁 $dir_name ${GRAY}|${LIGHT_GRAY} 🤖 $model_name${RESET}"

# Build the second line: costs and tokens
second_line="${LIGHT_GRAY}💰 \$${formatted_session_cost} ${GRAY}/${LIGHT_GRAY} 📅 \$${formatted_daily_cost} ${GRAY}/${LIGHT_GRAY} 🧊 \$${formatted_block_cost}"

if [ "$remaining_time" != "N/A" ]; then
    second_line="$second_line ($remaining_time left)"
fi

second_line="$second_line ${GRAY}|${LIGHT_GRAY} 🧩 ${formatted_tokens} ${GRAY}tokens${RESET}"

printf "%b\n%b\n" "$first_line" "$second_line"