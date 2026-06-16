# .cursor Folder

Cursor configuration for the Multichoice monorepo.

```
.cursor/
├── agents/       # Subagents (auto-delegated via description, or invoke by name)
├── commands/     # Slash commands (_workflow-base.md is shared internals)
├── references/   # Product and journey context (read on demand)
├── rules/        # Behavioral constraints (some always apply)
├── skills/       # Multi-step workflows (ticket-to-draft-pr, refresh-pr)
└── templates/    # Canonical code scaffolds
```

## Rules vs references

- **Rules** — how to write code, validate, and respect boundaries.
- **References** — what the app does, user journeys, feature flags, glossary.

## Rules (`rules/`)

| File | Scope |
|------|-------|
| `always-apply.mdc` | Scope, gates, secrets (every turn) |
| `development-workflow.mdc` | Melos, codegen, validation (every turn) |
| `project-structure.mdc` | Package ownership (every turn) |
| `code-organization.mdc` | Folder map (apps/packages) |
| `api-rules.mdc` | Core services, repos, models |
| `ui-rules.mdc` | Pages, widgets, constants |
| `testing-rules.mdc` | Tests and mocks |

## Commands (`commands/`)

| Command | Purpose |
|---------|---------|
| `feature` | Implement from GitHub issue |
| `fix` | Minimal bug/regression fix |
| `test` | Create or fix tests |
| `commit` | Split changes into logical commits |
| `create-pr` | Draft PR to `develop` |
| `changelog` | Update CHANGELOG from branch |

## Agents (`agents/`)

| Agent | Role |
|-------|------|
| `flutter-developer` | App UI, layouts, routing |
| `architecture-engineer` | Blocs, services, repos, models |
| `testing-engineer` | bloc_test, mocks, melos tests |
| `reviewer` | Read-only pre-PR review |
| `firebase-specialist` | Remote Config, Auth, Firestore |

## Templates (`templates/`)

| Template | Use for |
|----------|---------|
| `bloc-template.dart` | New feature bloc (event/state parts) |
| `repository-*-template.dart` | Repo interface + implementation |
| `service-*-template.dart` | Service interface + implementation |
| `page-template.dart` | auto_route page with bloc |
| `bloc-test-template.dart` | Bloc unit tests |
| `repository-test-template.dart` | Delegation repo tests |
| `test-template.dart` | Generic tests |
| `freezed-model-template.dart` | Models in `packages/models` |
| `snippets.json` | Optional VS Code snippets |

Adapt templates to nearby code before committing.

## References (`references/`)

See [references/README.md](references/README.md) for the index.

## Skills (`skills/`)

| Skill | Purpose |
|-------|---------|
| `ticket-to-draft-pr` | Issue → implement → changelog → commits → draft PR |
| `refresh-pr` | Update existing PR with latest base, rewrite body from diff |

## Maintenance

See [LAST_UPDATE.md](LAST_UPDATE.md) for audit history and when context was last refreshed.
