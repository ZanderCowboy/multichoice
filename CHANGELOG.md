# 436 - BoardView Ui Kit Widget

## Multichoice home

- No user-facing change in the main app yet — home collections still use the existing layout
- Cross-collection drag/drop in Multichoice is tracked separately (#437)

## Board playground (dev / QA)

- New local-only `Board Demo` launch config for manual board testing (`apps/board_demo`, Melos-ignored)
- Verify vertical and horizontal boards: reorder items within a collection, move items across collections, reorder collections via header handle (edit mode)
- Verify empty collections, insert gap while dragging, and edge auto-scroll while dragging near viewport edges

## Regression smoke tests

- Main app create / edit / reorder / delete tabs and entries still works as before
- Language selection and feedback flows unchanged
