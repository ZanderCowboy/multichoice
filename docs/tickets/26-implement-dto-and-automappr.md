# [Implement DTO and AutoMappr](https://github.com/ZanderCowboy/multichoice/issues/26)

## Ticket: [26](https://github.com/ZanderCowboy/multichoice/issues/26)

### branch: `26-implement-dto-and-automappr`

### Overview

This ticket is primarily to set up `DTO's` and `AutoMapper's` for our codebase. It allows us to separate our `database` models from our front-end's models.

### What was done

- [X] Added `auto_mappr` and `auto_mappr_annotation` to our pubspec packages
- [X] Added `EntryDTO` and `EntryMapper` for entries
- [X] Added `TabsDTO` and `TabsMapper` for tabs
- [X] Refactored codebase to rely on the DTOs and AutoMappers
- [X] Moved database models to new `models` folder

### Resources

- [`auto_mappr`](https://pub.dev/packages/auto_mappr)
