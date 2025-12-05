#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Function to print info
info() {
    echo -e "${GREEN}$1${NC}" >&2
}

# Function to print warning
warn() {
    echo -e "${YELLOW}$1${NC}" >&2
}

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    error_exit "GitHub CLI (gh) is not installed. Please install it first."
fi

# Check if tree is installed
if ! command -v tree &> /dev/null; then
    warn "tree command is not installed. Directory structure will be limited."
    TREE_AVAILABLE=false
else
    TREE_AVAILABLE=true
fi

# Parse arguments
GITHUB_URL="$1"
MODE=""
REPO_PATH=""
REPO_NAME=""
OWNER=""

# Determine mode
if [ -z "$GITHUB_URL" ]; then
    # Mode 2: Current directory
    if git rev-parse --git-dir > /dev/null 2>&1; then
        MODE="current"
        REPO_PATH=$(pwd)
        REPO_NAME=$(basename "$REPO_PATH")

        # Try to get remote URL
        if git remote get-url origin > /dev/null 2>&1; then
            GITHUB_URL=$(git remote get-url origin)
            # Convert SSH to HTTPS if needed
            if [[ "$GITHUB_URL" == git@github.com:* ]]; then
                GITHUB_URL=$(echo "$GITHUB_URL" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$||')
            fi
        fi

        info "Using current directory: $REPO_PATH"
    else
        error_exit "Current directory is not a git repository and no URL provided."
    fi
else
    # Mode 1: Clone from URL
    MODE="url"

    # Parse owner and repo from URL
    if [[ "$GITHUB_URL" =~ github\.com[:/]([^/]+)/([^/\.]+) ]]; then
        OWNER="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
    else
        error_exit "Invalid GitHub URL format: $GITHUB_URL"
    fi

    REPO_PATH="$HOME/Documents/clone/$REPO_NAME"

    # Check if directory already exists
    if [ -d "$REPO_PATH" ]; then
        warn "Directory $REPO_PATH already exists."
        # Return info to let LLM ask user
        echo '{"status":"exists","repo_path":"'"$REPO_PATH"'","repo_name":"'"$REPO_NAME"'"}'
        exit 0
    fi

    # Clone repository
    info "Cloning $GITHUB_URL to $REPO_PATH..."
    mkdir -p "$(dirname "$REPO_PATH")"
    git clone "$GITHUB_URL" "$REPO_PATH" >&2 || error_exit "Failed to clone repository"
    info "Repository cloned successfully"
fi

# Change to repo directory
cd "$REPO_PATH" || error_exit "Failed to change to repository directory"

# Collect metadata using gh CLI
info "Collecting metadata..."
METADATA_JSON="{}"

if [ -n "$GITHUB_URL" ] && [[ "$GITHUB_URL" == https://github.com/* ]]; then
    # Extract owner/repo from URL
    if [ -z "$OWNER" ]; then
        if [[ "$GITHUB_URL" =~ github\.com/([^/]+)/([^/\.]+) ]]; then
            OWNER="${BASH_REMATCH[1]}"
            REPO_NAME="${BASH_REMATCH[2]}"
        fi
    fi

    if [ -n "$OWNER" ] && [ -n "$REPO_NAME" ]; then
        # Get repo info using gh API
        REPO_INFO=$(gh api "repos/$OWNER/$REPO_NAME" 2>/dev/null || echo "{}")

        if [ "$REPO_INFO" != "{}" ]; then
            STARS=$(echo "$REPO_INFO" | jq -r '.stargazers_count // 0')
            FORKS=$(echo "$REPO_INFO" | jq -r '.forks_count // 0')
            LICENSE=$(echo "$REPO_INFO" | jq -r '.license.spdx_id // "None"')
            DESCRIPTION=$(echo "$REPO_INFO" | jq -r '.description // ""')
            UPDATED_AT=$(echo "$REPO_INFO" | jq -r '.updated_at // ""')

            METADATA_JSON=$(jq -n \
                --arg url "$GITHUB_URL" \
                --arg desc "$DESCRIPTION" \
                --argjson stars "$STARS" \
                --argjson forks "$FORKS" \
                --arg license "$LICENSE" \
                --arg updated "$UPDATED_AT" \
                '{url: $url, description: $desc, stars: $stars, forks: $forks, license: $license, last_commit: $updated}')
        fi
    fi
fi

# Get directory structure
info "Collecting directory structure..."
STRUCTURE=""
if [ "$TREE_AVAILABLE" = true ]; then
    STRUCTURE=$(tree -L 3 -I 'node_modules|.git|dist|build|__pycache__|*.pyc|.next|.nuxt|target|vendor' --charset ascii 2>/dev/null || echo "")
else
    STRUCTURE=$(find . -maxdepth 3 -type d ! -path '*/node_modules/*' ! -path '*/.git/*' ! -path '*/dist/*' ! -path '*/build/*' 2>/dev/null | head -50 || echo "")
fi

# Detect tech stack files
info "Detecting tech stack files..."
TECH_FILES=$(jq -n \
    --argjson packagejson "$([ -f package.json ] && echo true || echo false)" \
    --argjson requirementstxt "$([ -f requirements.txt ] && echo true || echo false)" \
    --argjson gomod "$([ -f go.mod ] && echo true || echo false)" \
    --argjson cargotoml "$([ -f Cargo.toml ] && echo true || echo false)" \
    --argjson composerjson "$([ -f composer.json ] && echo true || echo false)" \
    --argjson gemfile "$([ -f Gemfile ] && echo true || echo false)" \
    --argjson pomxml "$([ -f pom.xml ] && echo true || echo false)" \
    --argjson buildgradle "$([ -f build.gradle ] && echo true || echo false)" \
    '{
        "package.json": $packagejson,
        "requirements.txt": $requirementstxt,
        "go.mod": $gomod,
        "Cargo.toml": $cargotoml,
        "composer.json": $composerjson,
        "Gemfile": $gemfile,
        "pom.xml": $pomxml,
        "build.gradle": $buildgradle
    }')

# Build final JSON output
info "Building final output..."
FINAL_JSON=$(jq -n \
    --arg mode "$MODE" \
    --arg repo_path "$REPO_PATH" \
    --arg repo_name "$REPO_NAME" \
    --argjson metadata "$METADATA_JSON" \
    --arg structure "$STRUCTURE" \
    --argjson tech_files "$TECH_FILES" \
    '{
        status: "success",
        mode: $mode,
        repo_path: $repo_path,
        repo_name: $repo_name,
        metadata: $metadata,
        structure: $structure,
        tech_stack_files: $tech_files
    }')

# Output JSON to stdout
echo "$FINAL_JSON"

info "Script completed successfully"
