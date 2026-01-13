# Janar's Claude Code Marketplace

My personal plugins for productive development.

## Plugins

-   `janars-setup`: This plugin provides **19 slash commands** and **11 specialized AI agents** to supercharge your development workflow.

## Quick Install

```bash
# Step 1: Add the marketplace
/plugin marketplace add JanarT19/janars-claude-code

# Step 2: Install the plugin(s)
/plugin install janars-setup@janars-claude-code
```

## Environment Variables

Using API key instead of logging in via /login? Add your Anthropic Claude API key as follows:

```bash
# --------------
# For Claude Code CLI
# --------------
cd ~/.claude

# Use files in this repo as reference:
nano api_key.sh
nano settings.json


# --------------
# For VS Code Extension
# --------------
# Modify settings.json:
"apiKeyHelper": "echo API_KEY_HERE", # (this will also support the CLI version)
```

## What's Inside

### 📋 Development Commands

-   `/new-task` - Analyze code for performance issues
-   `/code-explain` - Generate detailed explanations
-   `/code-optimize` - Performance optimization
-   `/code-cleanup` - Refactoring and cleanup
-   `/feature-plan` - Feature implementation planning
-   `/lint` - Linting and fixes
-   `/docs-generate` - Documentation generation

### 🔌 API Commands

**FastAPI:**

-   `/api-new-fastapi` - Create FastAPI endpoints with controller, service, and DTOs
-   `/api-test` - Test API endpoints
-   `/api-protect` - Add protection & validation

**Next.js:**

-   `/api-new-nextjs` - Create Next.js API routes with validation and TypeScript

### 🎨 UI Commands

**React:**

-   `/component-new-react` - Create React components with Material-UI
-   `/page-new-react` - Create React pages with routing

**Next.js:**

-   `/component-new-nextjs` - Create Next.js components
-   `/page-new-nextjs` - Create Next.js pages

### 🗄️ Database Commands

-   `/liquibase-gen-changelogs` - Generate Liquibase migration changelogs for PostgreSQL

### 🤖 Specialized AI Agents

**Architecture & Planning**

-   **tech-stack-researcher** - Technology choice recommendations with trade-offs
-   **system-architect** - Scalable system architecture design
-   **backend-architect** - Backend systems with data integrity & security
-   **frontend-architect** - Performant, accessible UI architecture
-   **requirements-analyst** - Transform ideas into concrete specifications

**Code Quality & Performance**

-   **refactoring-expert** - Systematic refactoring and clean code
-   **performance-engineer** - Measurement-driven optimization
-   **security-engineer** - Vulnerability identification and security standards

**Documentation & Research**

-   **technical-writer** - Clear, comprehensive documentation
-   **learning-guide** - Teaching programming concepts progressively
-   **deep-research-agent** - Comprehensive research with adaptive strategies

## Installation

### From GitHub

```bash
# Add marketplace
/plugin marketplace add JanarT19/janars-claude-code

# Install plugin(s)
/plugin install janars-setup@janars-claude-code
```

## Best For

-   Next.js developers
-   React developers
-   FastAPI developers
-   PostgreSQL users
-   Full-stack engineers

## Usage Examples

### Planning a Feature

```bash
/feature-plan
# Then describe your feature idea
```

### Creating an API

**For FastAPI:**

```bash
/api-new-fastapi
# Claude will scaffold controller, service, DTOs, and entity following your project patterns
```

**For Next.js:**

```bash
/api-new-nextjs
# Claude will create Next.js API route with Zod validation and TypeScript
```

### Creating UI Components

**For React with Material-UI:**

```bash
/component-new-react
# Creates React component with MUI patterns

/page-new-react
# Creates full page with routing integration
```

### Database Migrations

```bash
/liquibase-gen-changelogs
# Generates Liquibase SQL changelogs from Pydantic models or user specifications
```

### Research Tech Choices

Just ask Claude questions like:

-   "Should I use WebSockets or SSE?"
-   "How should I structure this database?"
-   "What's the best library for X?"

The tech-stack-researcher agent automatically activates and provides detailed, researched answers.

## Philosophy

This setup emphasizes:

-   **Type Safety**: Never uses `any` types
-   **Best Practices**: Follows modern Next.js/React patterns
-   **Productivity**: Reduces repetitive scaffolding
-   **Research**: AI-powered tech decisions with evidence

## Requirements

-   Claude Code 2.0.13+
-   Works with any project (optimized for Next.js + FastAPI + PostgreSQL)

## Contributing

Feel free to:

-   Fork and customize for your needs
-   Submit issues or suggestions
-   Share your improvements

## License

MIT - Use freely in your projects

## Author

Created by Edmund, modified by Janar
