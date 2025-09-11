# Fork Synchronization Guide

This guide explains how to properly sync your fork of Et-Futurum-Requiem with the upstream repository.

## Understanding the Repository Structure

- **Upstream**: `Roadhog360/Et-Futurum-Requiem` (original repository)
- **Fork**: `MalTeeez/Et-Futurum-Requiem` (this repository)

## GitHub CLI Sync Commands

### Correct Syntax for Basic Sync

The GitHub CLI `gh repo sync` command has specific syntax requirements:

```bash
# Sync your fork's default branch with upstream's default branch
gh repo sync MalTeeez/Et-Futurum-Requiem --source Roadhog360/Et-Futurum-Requiem

# Sync a specific branch (must have same name in both repos)
gh repo sync MalTeeez/Et-Futurum-Requiem --branch master --source Roadhog360/Et-Futurum-Requiem
```

### ❌ Common Mistakes

```bash
# INCORRECT: Using colon syntax in --source
gh repo sync MalTeeez/Et-Futurum-Requiem --source Roadhog360/Et-Futurum-Requiem:master

# INCORRECT: Trying to sync different branch names directly
gh repo sync MalTeeez/Et-Futurum-Requiem --branch upstream-pr-3 --source Roadhog360/Et-Futurum-Requiem:master
```

## Authentication Setup

Before using GitHub CLI, ensure you're authenticated:

```bash
# Set up authentication
gh auth login

# Or set token for GitHub Actions
export GH_TOKEN="your_github_token"
```

## Cross-Branch Sync Workflow

To sync from upstream's `master` to your fork's `upstream-pr-3` branch:

### Option 1: Using Git Commands

```bash
# Add upstream remote if not already added
git remote add upstream https://github.com/Roadhog360/Et-Futurum-Requiem.git

# Fetch latest changes from upstream
git fetch upstream

# Switch to your target branch
git checkout upstream-pr-3

# Merge or reset to upstream master
git merge upstream/master
# OR for a hard reset: git reset --hard upstream/master

# Push changes to your fork
git push origin upstream-pr-3
```

### Option 2: Two-Step GitHub CLI Process

```bash
# Step 1: Sync master branch first
gh repo sync MalTeeez/Et-Futurum-Requiem --branch master --source Roadhog360/Et-Futurum-Requiem

# Step 2: Use git to update your specific branch
git checkout upstream-pr-3
git merge origin/master
git push origin upstream-pr-3
```

## Automated Sync with GitHub Actions

Consider setting up a GitHub Action for regular syncing:

```yaml
name: Sync Fork
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly sync
  workflow_dispatch:      # Manual trigger

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Sync upstream changes
        run: |
          git remote add upstream https://github.com/Roadhog360/Et-Futurum-Requiem.git
          git fetch upstream
          git checkout master
          git merge upstream/master
          git push origin master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Best Practices

1. **Regular Syncing**: Sync your fork regularly to avoid large merge conflicts
2. **Branch Strategy**: Keep your `master` branch clean and up-to-date with upstream
3. **Feature Branches**: Create separate branches for your changes (`upstream-pr-*`)
4. **Testing**: Always test after syncing to ensure compatibility

## Troubleshooting

### "Behind by X commits" Error
```bash
# Force sync (use with caution)
gh repo sync MalTeeez/Et-Futurum-Requiem --source Roadhog360/Et-Futurum-Requiem --force
```

### Merge Conflicts
1. Resolve conflicts manually in your editor
2. Use `git add .` to stage resolved files
3. Use `git commit` to complete the merge
4. Push the resolved changes

### Authentication Issues
- Ensure `gh auth status` shows you're logged in
- For GitHub Actions, verify `GITHUB_TOKEN` permissions
- Check if your token has `repo` scope for private repositories