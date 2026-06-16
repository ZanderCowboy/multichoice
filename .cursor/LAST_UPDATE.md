# Last Update

**Date:** 2026-06-15  
**Previous major overhaul:** 2026-06-13 — PR #385 (`feat: update .cursor folder to ensure context engineering…`)

## Audit summary

Reviewed `.cursor/` against the repo after the slang i18n migration (#388), DEV/PROD flavors, Android-only scope, and Remote Config debug overrides. The June 13 overhaul structure remains sound: slim always-apply rules, on-demand references, shared `_workflow-base.md`, deduplicated commands.

## Gaps found (since 2026-06-13)

| Gap | Resolution |
|-----|------------|
| No i18n/slang documentation | Added `references/architecture/i18n.md`; pointers in `ui-rules`, `code-organization`, `codegen-and-di`, agents |
| `changelog` command said "replace all contents" | Fixed to **prepend** section — matches real `CHANGELOG.md` shape, avoids destructive edits |
| Product overview stale (platform, flavors, locales) | Updated `product-overview.md` |
| Debug RC overrides underspecified | Expanded `feature-flags.md` and `feedback-and-settings.md` |
| `skills/` not indexed | Added to `README.md` |
| `melos slang` / `strings.g.dart` missing from workflow | Added to `development-workflow.mdc` and `codegen-and-di.md` |

## No change needed

- **Always-apply rules** (~60 lines total) — still lean; no pattern duplication.
- **Commands** (`feature`, `fix`, `test`, `commit`, `create-pr`) — still delegate to `_workflow-base.md`.
- **Templates** — align with bloc/repo/service patterns; no `example-*` stale paths in active files.
- **Agents** — descriptions and workflows still valid.
- **Skills** — `ticket-to-draft-pr` and `refresh-pr` already reference commands/rules correctly.
- **`plans/`** — historical; not loaded by Cursor rules; left as-is.

## Context engineering principles (ongoing)

1. **Rules** = behavioral constraints only (how to work).
2. **References** = factual/product context (what the app is) — read on demand, not every turn.
3. **Templates** = canonical code shapes — read when scaffolding.
4. **Commands/skills** = orchestration pointers — link to rules/references, avoid inlining long instructions.
5. **Avoid** repeating melos/validation/boundaries across always-apply rules and commands.

## Next review triggers

- New cross-cutting pattern (e.g. new package, persistence layer, auth provider).
- New Remote Config keys or major user journey.
- Always-apply rule count grows past ~80 lines combined — re-audit for duplication.
