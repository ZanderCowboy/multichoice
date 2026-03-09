# .cursor Folder Guide

This directory contains rules and plans that help Cursor AI understand your project better and provide more accurate assistance.

## Directory Structure

```
.cursor/
├── rules/          # AI assistant rules and guidelines
├── plans/          # Project plans and feature documentation
├── templates/      # Code templates for reuse
└── README.md       # This file
```

## Rules Directory (`rules/`)

Rules are markdown files (`.mdc`) that guide the AI assistant's behavior. Each rule file has frontmatter metadata:

### Frontmatter Options

```yaml
---
description: Brief description of what this rule covers
globs: ["**/*.dart"]  # File patterns this rule applies to
alwaysApply: false     # Whether to always apply this rule
---
```

### Rule File Examples

1. **Language-Specific Rules** (`example-language-specific.mdc`)
   - Apply to specific file types using glob patterns
   - Example: Dart-specific conventions

2. **Always Apply Rules** (`example-always-apply.mdc`)
   - Rules that apply to every conversation
   - Use `alwaysApply: true`
   - Good for project-wide conventions

3. **Conditional Rules** (`example-conditional-rules.mdc`)
   - Apply to specific directories or patterns
   - Example: Core package rules, feature module rules

4. **Testing Rules** (`example-testing-rules.mdc`)
   - Rules for test files
   - Testing conventions and best practices

5. **API/Service Rules** (`example-api-rules.mdc`)
   - Rules for service layer code
   - Interface/implementation patterns

6. **UI Rules** (`example-ui-rules.mdc`)
   - Widget and UI development guidelines
   - Page structure conventions

7. **Complex Globs** (`example-complex-globs.mdc`)
   - Advanced glob pattern examples
   - Inclusion and exclusion patterns

8. **Shortcuts** (`example-shortcuts.mdc`)
   - Quick reference for common tasks
   - Build commands, testing commands, etc.

9. **Reusable Patterns** (`example-reusable-patterns.mdc`)
   - Common code patterns the AI can reference
   - Service, page, test, repository patterns

### Glob Pattern Examples

```yaml
# Single pattern
globs: ["**/*.dart"]

# Multiple patterns
globs: ["**/*.dart", "**/*.ts"]

# Directory-specific
globs: ["packages/core/**"]

# Exclude patterns (use !)
globs: 
  - "**/*.dart"
  - "!**/*.g.dart"        # Exclude generated files
  - "!**/test/**"         # Exclude test directories

# Multiple file types
globs: ["**/*.{dart,ts,js}"]
```

## Plans Directory (`plans/`)

Plans are markdown files that document features, refactoring efforts, or project goals.

### Plan File Examples

1. **Feature Plan** (`example-feature-plan.mdc`)
   - Structure for planning new features
   - Includes goals, requirements, implementation steps

2. **Refactoring Plan** (`example-refactoring-plan.mdc`)
   - Structure for refactoring efforts
   - Includes current state, target state, migration strategy

### Plan Frontmatter

```yaml
---
title: Plan Title
status: planning | in-progress | completed | cancelled
priority: low | medium | high
tags: [tag1, tag2, tag3]
---
```

## Templates Directory (`templates/`)

Template files are complete code files you can copy and customize.

### Available Templates

1. **Service Template** (`example-service-template.dart`)
   - Service interface + implementation structure
   - Includes dependency injection setup

2. **Page Template** (`example-page-template.dart`)
   - Flutter page with Scaffold structure
   - Follows project conventions

3. **Test Template** (`example-test-template.dart`)
   - Test file structure with setup/teardown
   - Arrange-Act-Assert pattern

4. **Freezed Model Template** (`example-freezed-model-template.dart`)
   - Freezed model with JSON serialization
   - Ready for code generation

5. **Snippets Examples** (`example-snippets.json`)
   - Example snippets for `.vscode/snippets.code-snippets`
   - Service, page, widget, model snippets

## Best Practices

1. **Keep Rules Focused**
   - One rule file per concern or domain
   - Don't mix unrelated guidelines

2. **Use Descriptive Names**
   - Name files clearly: `testing-rules.mdc`, `ui-guidelines.mdc`
   - Use kebab-case for file names

3. **Organize by Domain**
   - Group related rules together
   - Use subdirectories if needed (e.g., `rules/ui/`, `rules/testing/`)

4. **Keep Plans Updated**
   - Update plan status as work progresses
   - Add notes and learnings

5. **Use Always Apply Sparingly**
   - Only use `alwaysApply: true` for critical, universal rules
   - Most rules should be context-specific

## Creating Your Own Rules

1. Create a new `.mdc` file in `rules/`
2. Add frontmatter with appropriate metadata
3. Write clear, actionable guidelines
4. Use code examples when helpful
5. Reference existing patterns in your codebase

## Creating Your Own Plans

1. Create a new `.mdc` file in `plans/`
2. Add frontmatter with title, status, priority, tags
3. Document the plan following the examples
4. Update status as work progresses

## Reusable Content

For information on creating reusable code snippets, templates, and patterns, see:
- **[REUSABLE-CONTENT-GUIDE.md](REUSABLE-CONTENT-GUIDE.md)** - Complete guide on all reusable content options

### Quick Summary

1. **Code Snippets** (`.vscode/snippets.code-snippets`) - Fast code insertion
2. **Templates** (`.cursor/templates/`) - Complete file templates
3. **Reusable Patterns** (`.cursor/rules/example-reusable-patterns.mdc`) - AI-referenced patterns
4. **Example Snippets** (`.cursor/templates/example-snippets.json`) - More snippet examples

## Tips

- Start with a few key rules and expand as needed
- Review and update rules regularly
- Remove outdated or conflicting rules
- Use plans to track complex features or refactoring
- Reference existing code patterns in your rules
- Use snippets for frequently used code blocks
- Use templates for complete file structures
