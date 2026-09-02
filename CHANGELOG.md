# 436 - Harden BoardView Widget

## Multichoice home

- No user-facing change in the main app — home collections still use the existing layout
- Multichoice adoption of BoardView remains deferred (#437)

## Board playground (dev / QA)

- Launch **Board Demo** (`apps/board_demo`, local-only)
- Vertical layout: dragged item ghost should match the collection column width (not a wider overlay)
- Horizontal layout: dragged item ghost should match the collection card height
- Collection reorder: a full-size drop gap appears as soon as a collection is picked up
- Horizontal layout with a long collection title: header + items should not overflow the card
- While dragging a collection, the floating chip can show a title instead of the raw collection id

## Regression smoke tests

- Main app create / edit / reorder / delete tabs and entries still works as before
- Existing Board Demo item moves, cross-collection moves, and collection reorder still work
