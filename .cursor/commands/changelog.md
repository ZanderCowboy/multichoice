Please look at the `git diffs` and update the CHANGELOG.md (path: `CHANGELOG.md`) in a bullet list format. 

First, run `git branch --show-current` to get the current branch name and extract the ticket number from the start of the branch name.

Follow this structure:
```
#<ticket-number> - GitHub Issue Title

- Item
- Item
```

To get the ticket number, extract it from the start of the current branch name (e.g., "7-implement-draggable" -> ticket #7).
The title should be in Camel Case based on the branch name (e.g., "implement-draggable" -> "Implement Draggable").
Replace the existing contents.
Do not over explain. It should just have enough details to capture the purpose of the code changes. 

