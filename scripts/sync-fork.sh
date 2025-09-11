#!/bin/bash

# Fork Sync Helper Script
# This script demonstrates the correct way to sync your fork with upstream

set -e

UPSTREAM_REPO="Roadhog360/Et-Futurum-Requiem"
FORK_REPO="MalTeeez/Et-Futurum-Requiem"

echo "🔄 Fork Sync Helper for Et-Futurum-Requiem"
echo "==========================================="
echo ""

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed or not in PATH"
    echo "📥 Install from: https://cli.github.com/"
    exit 1
fi

# Check authentication (skip for info commands)
if [[ "${1:-help}" != "examples" && "${1:-help}" != "git" && "${1:-help}" != "help" ]]; then
    if ! gh auth status &> /dev/null; then
        echo "🔐 Not authenticated with GitHub CLI"
        echo "💡 Run: gh auth login"
        exit 1
    fi
    echo "✅ GitHub CLI is ready"
    echo ""
fi

# Function to sync master branch
sync_master() {
    echo "🔄 Syncing master branch..."
    if gh repo sync "$FORK_REPO" --source "$UPSTREAM_REPO"; then
        echo "✅ Master branch synced successfully"
    else
        echo "❌ Failed to sync master branch"
        echo "💡 Try with --force flag if you're sure: gh repo sync $FORK_REPO --source $UPSTREAM_REPO --force"
        return 1
    fi
}

# Function to sync specific branch
sync_branch() {
    local branch="$1"
    echo "🔄 Syncing branch: $branch"
    
    if gh repo sync "$FORK_REPO" --branch "$branch" --source "$UPSTREAM_REPO"; then
        echo "✅ Branch $branch synced successfully"
    else
        echo "❌ Failed to sync branch $branch"
        echo "💡 This might fail if the branch names don't match exactly"
        echo "💡 For cross-branch syncing, use git commands instead:"
        echo "   git fetch upstream"
        echo "   git checkout $branch"
        echo "   git merge upstream/master"
        echo "   git push origin $branch"
        return 1
    fi
}

# Function to show correct command examples
show_examples() {
    echo "📚 Correct GitHub CLI sync commands:"
    echo ""
    echo "✅ Sync master branch:"
    echo "   gh repo sync $FORK_REPO --source $UPSTREAM_REPO"
    echo ""
    echo "✅ Sync specific branch (same name in both repos):"
    echo "   gh repo sync $FORK_REPO --branch master --source $UPSTREAM_REPO"
    echo ""
    echo "❌ INCORRECT - Don't use colon syntax:"
    echo "   gh repo sync $FORK_REPO --source $UPSTREAM_REPO:master"
    echo ""
    echo "❌ INCORRECT - Can't sync different branch names directly:"
    echo "   gh repo sync $FORK_REPO --branch upstream-pr-3 --source $UPSTREAM_REPO:master"
    echo ""
}

# Function to show git-based alternative
show_git_alternative() {
    echo "🔧 Alternative using Git commands:"
    echo ""
    echo "git remote add upstream https://github.com/$UPSTREAM_REPO.git"
    echo "git fetch upstream"
    echo "git checkout upstream-pr-3"
    echo "git merge upstream/master"
    echo "git push origin upstream-pr-3"
    echo ""
}

# Main menu
case "${1:-help}" in
    "master")
        sync_master
        ;;
    "branch")
        if [ -z "$2" ]; then
            echo "❌ Branch name required"
            echo "💡 Usage: $0 branch <branch-name>"
            exit 1
        fi
        sync_branch "$2"
        ;;
    "examples")
        show_examples
        ;;
    "git")
        show_git_alternative
        ;;
    "help"|*)
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  master          - Sync master branch with upstream"
        echo "  branch <name>   - Sync specific branch with upstream"
        echo "  examples        - Show correct command examples"
        echo "  git             - Show git-based alternative"
        echo "  help            - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 master"
        echo "  $0 branch upstream-pr-3"
        echo "  $0 examples"
        ;;
esac