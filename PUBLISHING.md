# Publishing Guide: Janar's Claude Code Plugin

Complete guide for publishing your Claude Code plugin to GitHub and making it discoverable through the plugin ecosystem.

## Prerequisites

-   [ ] GitHub account
-   [ ] Git installed locally
-   [ ] Claude Code version 1.0.33 or later (check with `claude --version`)
-   [ ] Plugin manifest (`.claude-plugin/plugin.json`) properly configured ✅
-   [ ] All commands and agents tested locally ✅

## Step 1: Create GitHub Repository

### 1.1 Create New Repository on GitHub

1. Go to https://github.com/new
2. Configure repository:
    - **Repository name**: `janars-claude-code`
    - **Description**: "Janar's personal Claude Code setup with productivity commands and specialized AI agents for FastAPI, React, Next.js, and PostgreSQL development"
    - **Visibility**: Public (required for plugin installation)
    - **Initialize**: ❌ Don't add README, .gitignore, or license (we already have these)
    - **Topics**: Add `claude-code-plugin`, `claude-code`, `productivity`, `fastapi`, `react`, `nextjs`, `postgresql`
3. Click "Create repository"

### 1.2 Push Your Local Repository

Once created, push your code:

```bash
cd "path/to/janars-claude-code"

# Add the GitHub remote
git remote add origin https://github.com/JanarT19/janars-claude-code.git

# Push to GitHub
git push -u origin main
```

## Step 2: Test Installation

Verify your plugin installs correctly:

```bash
# Install from GitHub (username/repo format)
/plugin install JanarT19/janars-claude-code

# Test commands
/code-explain
/feature-plan
/api-new-fastapi

# Agents activate automatically based on context
```

Uninstall to test again:

```bash
/plugin uninstall janars-claude-code
```

Users can also install via full URL:

```bash
/plugin install https://github.com/JanarT19/janars-claude-code
```

## Step 3: Submit to Plugin Directories

### Option A: Official Plugin Directory

Submit to the [official Anthropic-managed directory](https://github.com/anthropics/claude-plugins-official):

1. Fork `anthropics/claude-plugins-official`
2. Add your plugin to the catalog
3. Submit a pull request
4. Wait for review and approval

**Benefits**: Highest visibility, official endorsement, quality-vetted

### Option B: Community Marketplaces

Add to popular community marketplaces:

**cc-marketplace** (592+ stars)

```bash
# Users add the marketplace
/plugin marketplace add https://github.com/ananddtyagi/cc-marketplace

# Then install your plugin
/plugin install janars-claude-code
```

**superpowers-marketplace** (286+ stars)

```bash
/plugin marketplace add https://github.com/anthropics/superpowers-marketplace
```

To submit: Open a PR to the respective marketplace repository

### Option C: Community Listing Sites

Add your plugin to:

-   [ClaudeMarketplaces.com](https://claudemarketplaces.com/)
-   [ClaudeCodeMarketplace.com](https://claudecodemarketplace.com/)
-   [awesome-claude-plugins](https://github.com/quemsah/awesome-claude-plugins) (automated tracking)

## Step 4: Share Your Plugin

### Direct Sharing

Share your plugin installation command:

```bash
# Short form (GitHub only)
/plugin install JanarT19/janars-claude-code

# Full URL (works with any git host)
/plugin install https://github.com/JanarT19/janars-claude-code
```

## Step 5: Maintain Your Plugin

### Updating Your Plugin

When making changes:

```bash
cd "path/to/janars-claude-code"

# Make your changes to commands/agents
# Test locally first!

# Stage and commit changes
git add .
git commit -m "Add /db-migrate command for PostgreSQL migrations"

# Update version in .claude-plugin/plugin.json
# Follow semantic versioning (see below)

git add .claude-plugin/plugin.json
git commit -m "Bump version to 1.1.0"

git push
```

Users update with:

```bash
/plugin update janars-claude-code
```

Or refresh from a marketplace:

```bash
/plugin marketplace update cc-marketplace
```

### Versioning Guidelines (Semantic Versioning)

Follow [semver.org](https://semver.org/):

-   **1.0.x** → **1.0.1** - Bug fixes, typo corrections, documentation updates
-   **1.x.0** → **1.1.0** - New commands/agents, backward-compatible features
-   **x.0.0** → **2.0.0** - Breaking changes, major restructuring, removed commands

Example:

-   Fix typo in command → `1.0.0` → `1.0.1`
-   Add new `/db-backup` command → `1.0.1` → `1.1.0`
-   Rename all commands → `1.1.0` → `2.0.0`

## Step 6: Create GitHub Releases (Optional but Recommended)

Releases provide version snapshots and changelogs:

1. Navigate to your repo: https://github.com/JanarT19/janars-claude-code
2. Click **Releases** → **Create a new release**
3. Configure:

    - **Tag**: `v1.0.0` (must match `plugin.json` version)
    - **Title**: `v1.0.0 - Initial Release`
    - **Description**:

        ```markdown
        ## Features

        -   14 productivity commands (/api-new-fastapi, /component-new-react, etc.)
        -   11 specialized AI agents (backend-architect, security-engineer, etc.)
        -   MCP servers for Context7 and Playwright

        ## Tech Stack Support

        -   FastAPI + PostgreSQL backends
        -   React + Material-UI frontends
        -   Next.js applications
        -   Liquibase migrations

        ## Installation

        `/plugin install JanarT19/janars-claude-code`
        ```

4. Click **Publish release**

Users can install specific versions:

```bash
/plugin install JanarT19/janars-claude-code@v1.0.0
/plugin install JanarT19/janars-claude-code@v1.2.0
```

## Resources

### Official Documentation

-   [Plugin Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) - Creating and distributing plugins
-   [Discover Plugins](https://code.claude.com/docs/en/discover-plugins) - Installation methods
-   [Claude Code Plugins README](https://github.com/anthropics/claude-code/blob/main/plugins/README.md) - Official guide

### Repositories

-   [anthropics/claude-code](https://github.com/anthropics/claude-code) - Main repository
-   [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) - Official directory
-   [ananddtyagi/cc-marketplace](https://github.com/ananddtyagi/cc-marketplace) - Popular community marketplace

### Community

-   GitHub Topics: [claude-code-plugin](https://github.com/topics/claude-code-plugin)
-   [awesome-claude-plugins](https://github.com/quemsah/awesome-claude-plugins) - Curated list
-   [ClaudeMarketplaces.com](https://claudemarketplaces.com/) - Plugin discovery

### Getting Help

-   [Claude Code Issues](https://github.com/anthropics/claude-code/issues) - Report bugs
-   [CHANGELOG](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) - Latest updates
-   Community Discord/Slack - Ask questions
